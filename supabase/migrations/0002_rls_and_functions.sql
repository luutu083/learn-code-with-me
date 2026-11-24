-- ============================================================================
-- Learn Code With Me — Row Level Security (RLS), Triggers & Auth Guards
-- Migration: 0002_rls_and_functions.sql
-- ============================================================================

-- Helper: Check if the currently authenticated user has ADMIN role
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid() AND role = 'ADMIN'
  );
$$;

-- Trigger: Auto-update updated_at column
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Trigger: Auto-create profile row when a new auth.users record is created
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(COALESCE(NEW.email, 'user'), '@', 1)),
    'USER'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Security Trigger: Prevent non-service-role users from escalating their own role to ADMIN
CREATE OR REPLACE FUNCTION public.prevent_role_escalation()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.role IS DISTINCT FROM OLD.role THEN
    IF current_setting('role', true) <> 'service_role' AND NOT public.is_admin() THEN
      RAISE EXCEPTION 'Unauthorized: cannot modify user role';
    END IF;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_prevent_role_escalation ON public.profiles;
CREATE TRIGGER trg_prevent_role_escalation
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.prevent_role_escalation();

-- Updated_at triggers
DROP TRIGGER IF EXISTS trg_profiles_updated_at ON public.profiles;
CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_courses_updated_at ON public.courses;
CREATE TRIGGER trg_courses_updated_at BEFORE UPDATE ON public.courses FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_chapters_updated_at ON public.chapters;
CREATE TRIGGER trg_chapters_updated_at BEFORE UPDATE ON public.chapters FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_lessons_updated_at ON public.lessons;
CREATE TRIGGER trg_lessons_updated_at BEFORE UPDATE ON public.lessons FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_exercises_updated_at ON public.exercises;
CREATE TRIGGER trg_exercises_updated_at BEFORE UPDATE ON public.exercises FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS trg_lesson_progress_updated_at ON public.lesson_progress;
CREATE TRIGGER trg_lesson_progress_updated_at BEFORE UPDATE ON public.lesson_progress FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================================================
-- Enable Row Level Security on ALL tables
-- ============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coding_test_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_verification_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;

-- 1. profiles
CREATE POLICY "Users can view own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id OR public.is_admin());

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- 2. courses, chapters, lessons, lesson_sources (read published for authenticated/public; full CRUD for admin)
CREATE POLICY "Read published courses" ON public.courses
  FOR SELECT USING (is_published = TRUE OR public.is_admin());
CREATE POLICY "Admin manage courses" ON public.courses
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Read published chapters" ON public.chapters
  FOR SELECT USING (is_published = TRUE OR public.is_admin());
CREATE POLICY "Admin manage chapters" ON public.chapters
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Read published lessons" ON public.lessons
  FOR SELECT USING (is_published = TRUE OR public.is_admin());
CREATE POLICY "Admin manage lessons" ON public.lessons
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Read lesson sources" ON public.lesson_sources
  FOR SELECT USING (TRUE);
CREATE POLICY "Admin manage lesson sources" ON public.lesson_sources
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- 3. exercises, coding_test_cases, quiz_questions, quiz_options
-- Note: solution_code, hidden test cases, and quiz_options.is_correct are NEVER queried directly by client components;
-- server routes use service_role and strip sensitive fields before returning to learners.
CREATE POLICY "Authenticated read exercises" ON public.exercises
  FOR SELECT USING (auth.role() = 'authenticated' OR public.is_admin());
CREATE POLICY "Admin manage exercises" ON public.exercises
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Read visible coding test cases only" ON public.coding_test_cases
  FOR SELECT USING ((auth.role() = 'authenticated' AND is_hidden = FALSE) OR public.is_admin());
CREATE POLICY "Admin manage coding test cases" ON public.coding_test_cases
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Authenticated read quiz questions" ON public.quiz_questions
  FOR SELECT USING (auth.role() = 'authenticated' OR public.is_admin());
CREATE POLICY "Admin manage quiz questions" ON public.quiz_questions
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

CREATE POLICY "Authenticated read quiz options" ON public.quiz_options
  FOR SELECT USING (auth.role() = 'authenticated' OR public.is_admin());
CREATE POLICY "Admin manage quiz options" ON public.quiz_options
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- 4. lesson_progress (Users can read own progress; writes go through verified server APIs using service_role to prevent score tampering)
CREATE POLICY "Users read own lesson progress" ON public.lesson_progress
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());
CREATE POLICY "Admin manage lesson progress" ON public.lesson_progress
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- 5. exercise_submissions (Read own; inserts/updates strictly server-side)
CREATE POLICY "Users read own exercise submissions" ON public.exercise_submissions
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

-- 6. quiz_attempts (Read own; inserts strictly server-side)
CREATE POLICY "Users read own quiz attempts" ON public.quiz_attempts
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

-- 7. user_activities (Read own; inserts server-side)
CREATE POLICY "Users read own activities" ON public.user_activities
  FOR SELECT USING (auth.uid() = user_id OR public.is_admin());

-- 8. ai_verification_logs (Read authenticated; write admin)
CREATE POLICY "Authenticated read verification logs" ON public.ai_verification_logs
  FOR SELECT USING (auth.role() = 'authenticated' OR public.is_admin());
CREATE POLICY "Admin manage verification logs" ON public.ai_verification_logs
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());

-- 9. platform_settings (Read authenticated; write admin)
CREATE POLICY "Authenticated read settings" ON public.platform_settings
  FOR SELECT USING (auth.role() = 'authenticated' OR public.is_admin());
CREATE POLICY "Admin manage settings" ON public.platform_settings
  FOR ALL USING (public.is_admin()) WITH CHECK (public.is_admin());
