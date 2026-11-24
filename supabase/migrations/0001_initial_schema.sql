-- ============================================================================
-- Learn Code With Me — Initial Normalized PostgreSQL Schema (Supabase)
-- Migration: 0001_initial_schema.sql
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enum types
DO $$ BEGIN
  CREATE TYPE user_role AS ENUM ('USER', 'ADMIN');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE programming_language AS ENUM ('c', 'python');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE verification_status AS ENUM ('verified', 'pending', 'needs_review', 'unverified');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE exercise_type AS ENUM ('coding', 'quiz');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE TYPE difficulty_level AS ENUM ('beginner', 'intermediate', 'advanced');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 1. profiles (linked 1:1 with auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL DEFAULT '',
  avatar_url TEXT,
  role user_role NOT NULL DEFAULT 'USER',
  preferred_language programming_language DEFAULT 'c',
  bio TEXT DEFAULT '',
  current_streak_days INTEGER NOT NULL DEFAULT 0 CHECK (current_streak_days >= 0),
  longest_streak_days INTEGER NOT NULL DEFAULT 0 CHECK (longest_streak_days >= 0),
  last_active_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. courses
CREATE TABLE IF NOT EXISTS public.courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  language programming_language NOT NULL,
  description TEXT NOT NULL,
  difficulty difficulty_level NOT NULL DEFAULT 'beginner',
  is_published BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. chapters
CREATE TABLE IF NOT EXISTS public.chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  slug TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_published BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (course_id, slug)
);

-- 4. lessons
CREATE TABLE IF NOT EXISTS public.lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  chapter_id UUID NOT NULL REFERENCES public.chapters(id) ON DELETE CASCADE,
  slug TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT NOT NULL DEFAULT '',
  content_markdown TEXT NOT NULL,
  code_example TEXT NOT NULL DEFAULT '',
  code_explanation TEXT NOT NULL DEFAULT '',
  common_mistakes TEXT NOT NULL DEFAULT '',
  key_takeaways TEXT NOT NULL DEFAULT '',
  language programming_language NOT NULL,
  language_version TEXT NOT NULL DEFAULT 'C11 / GCC 12',
  difficulty difficulty_level NOT NULL DEFAULT 'beginner',
  estimated_minutes INTEGER NOT NULL DEFAULT 15 CHECK (estimated_minutes > 0),
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_published BOOLEAN NOT NULL DEFAULT TRUE,
  verification_status verification_status NOT NULL DEFAULT 'pending',
  last_verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (course_id, slug)
);

-- 5. lesson_sources (Verified Knowledge metadata per lesson)
CREATE TABLE IF NOT EXISTS public.lesson_sources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  source_name TEXT NOT NULL,
  source_url TEXT NOT NULL CHECK (source_url ~ '^https?://'),
  programming_language programming_language NOT NULL,
  version TEXT NOT NULL,
  last_verified_date DATE NOT NULL DEFAULT CURRENT_DATE,
  verification_status verification_status NOT NULL DEFAULT 'verified',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 6. exercises (Mandatory exercise attached to each lesson)
CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  type exercise_type NOT NULL,
  instructions TEXT NOT NULL,
  language programming_language NOT NULL,
  starter_code TEXT DEFAULT '',
  solution_code TEXT DEFAULT '', -- Server-only: never exposed via public client queries
  sample_input TEXT DEFAULT '',
  sample_output TEXT DEFAULT '',
  pass_threshold INTEGER NOT NULL DEFAULT 100 CHECK (pass_threshold >= 0 AND pass_threshold <= 100),
  time_limit_ms INTEGER NOT NULL DEFAULT 2000 CHECK (time_limit_ms > 0 AND time_limit_ms <= 10000),
  memory_limit_kb INTEGER NOT NULL DEFAULT 128000 CHECK (memory_limit_kb >= 16384 AND memory_limit_kb <= 524288),
  is_required BOOLEAN NOT NULL DEFAULT TRUE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 7. coding_test_cases
CREATE TABLE IF NOT EXISTS public.coding_test_cases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT 'Test Case',
  input_data TEXT NOT NULL DEFAULT '',
  expected_output TEXT NOT NULL,
  is_hidden BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 8. quiz_questions (Exactly 5 questions per quiz enforced at API & validation layer)
CREATE TABLE IF NOT EXISTS public.quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  explanation TEXT NOT NULL,
  common_misconception TEXT NOT NULL DEFAULT '',
  sort_order INTEGER NOT NULL CHECK (sort_order >= 1 AND sort_order <= 5),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (exercise_id, sort_order)
);

-- 9. quiz_options (4 options per question, exactly 1 correct)
CREATE TABLE IF NOT EXISTS public.quiz_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES public.quiz_questions(id) ON DELETE CASCADE,
  option_label CHAR(1) NOT NULL CHECK (option_label IN ('A', 'B', 'C', 'D')),
  option_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT FALSE,
  UNIQUE (question_id, option_label)
);

-- 10. lesson_progress
CREATE TABLE IF NOT EXISTS public.lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  lesson_completed BOOLEAN NOT NULL DEFAULT FALSE,
  exercise_completed BOOLEAN NOT NULL DEFAULT FALSE,
  best_coding_score INTEGER NOT NULL DEFAULT 0 CHECK (best_coding_score >= 0 AND best_coding_score <= 100),
  best_quiz_score INTEGER NOT NULL DEFAULT 0 CHECK (best_quiz_score >= 0 AND best_quiz_score <= 100),
  attempts_count INTEGER NOT NULL DEFAULT 0 CHECK (attempts_count >= 0),
  time_spent_seconds INTEGER NOT NULL DEFAULT 0 CHECK (time_spent_seconds >= 0),
  last_accessed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, lesson_id)
);

-- 11. exercise_submissions (Coding submissions graded exclusively on server)
CREATE TABLE IF NOT EXISTS public.exercise_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  language programming_language NOT NULL,
  submitted_code TEXT NOT NULL,
  score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  passed BOOLEAN NOT NULL DEFAULT FALSE,
  passed_tests INTEGER NOT NULL DEFAULT 0,
  total_tests INTEGER NOT NULL DEFAULT 0,
  attempt_number INTEGER NOT NULL DEFAULT 1,
  execution_time_ms INTEGER,
  error_type TEXT, -- 'compile_error' | 'runtime_error' | 'wrong_answer' | 'time_limit' | null
  error_message TEXT,
  test_results_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 12. quiz_attempts (Quiz submissions graded exclusively on server)
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id) ON DELETE CASCADE,
  answers_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  correct_count INTEGER NOT NULL CHECK (correct_count >= 0 AND correct_count <= 5),
  total_questions INTEGER NOT NULL DEFAULT 5 CHECK (total_questions = 5),
  passed BOOLEAN NOT NULL DEFAULT FALSE,
  attempt_number INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 13. user_activities (Audit trail for Learner & Admin dashboards)
CREATE TABLE IF NOT EXISTS public.user_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  course_id UUID REFERENCES public.courses(id) ON DELETE SET NULL,
  lesson_id UUID REFERENCES public.lessons(id) ON DELETE SET NULL,
  exercise_id UUID REFERENCES public.exercises(id) ON DELETE SET NULL,
  activity_type TEXT NOT NULL, -- 'lesson_viewed' | 'code_tested' | 'code_submitted' | 'quiz_tested' | 'quiz_submitted' | 'ai_question'
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 14. ai_verification_logs (Verified Knowledge System audit log)
CREATE TABLE IF NOT EXISTS public.ai_verification_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID REFERENCES public.lessons(id) ON DELETE CASCADE,
  verified_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  programming_language programming_language NOT NULL,
  source_name TEXT NOT NULL,
  source_url TEXT NOT NULL,
  syntax_checked BOOLEAN NOT NULL DEFAULT FALSE,
  version_checked BOOLEAN NOT NULL DEFAULT FALSE,
  sandbox_executed BOOLEAN NOT NULL DEFAULT FALSE,
  sandbox_output_matched BOOLEAN NOT NULL DEFAULT FALSE,
  status verification_status NOT NULL DEFAULT 'pending',
  notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 15. platform_settings (Admin-configurable global controls, e.g. allow_skip_exercises)
CREATE TABLE IF NOT EXISTS public.platform_settings (
  key TEXT PRIMARY KEY,
  value JSONB NOT NULL,
  updated_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO public.platform_settings (key, value)
VALUES ('allow_skip_exercises', 'false'::jsonb)
ON CONFLICT (key) DO NOTHING;

-- ============================================================================
-- Indexes for query performance
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_chapters_course ON public.chapters(course_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_lessons_chapter ON public.lessons(chapter_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_lessons_course ON public.lessons(course_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_lesson_sources_lesson ON public.lesson_sources(lesson_id);
CREATE INDEX IF NOT EXISTS idx_exercises_lesson ON public.exercises(lesson_id);
CREATE INDEX IF NOT EXISTS idx_coding_test_cases_exercise ON public.coding_test_cases(exercise_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_exercise ON public.quiz_questions(exercise_id, sort_order);
CREATE INDEX IF NOT EXISTS idx_quiz_options_question ON public.quiz_options(question_id);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_user_course ON public.lesson_progress(user_id, course_id);
CREATE INDEX IF NOT EXISTS idx_exercise_submissions_user ON public.exercise_submissions(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_exercise_submissions_exercise ON public.exercise_submissions(exercise_id, passed);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user ON public.quiz_attempts(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_activities_user ON public.user_activities(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_ai_verification_logs_lesson ON public.ai_verification_logs(lesson_id, created_at DESC);
