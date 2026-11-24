export type UserRole = "USER" | "ADMIN";
export type ProgrammingLanguage = "c" | "python";
export type VerificationStatus = "verified" | "pending" | "needs_review" | "unverified";
export type ExerciseType = "coding" | "quiz";
export type DifficultyLevel = "beginner" | "intermediate" | "advanced";

export interface Profile {
  id: string;
  email: string;
  full_name: string;
  avatar_url: string | null;
  role: UserRole;
  preferred_language: ProgrammingLanguage | null;
  bio: string;
  current_streak_days: number;
  longest_streak_days: number;
  last_active_date: string | null;
  created_at: string;
  updated_at: string;
}

export interface Course {
  id: string;
  slug: string;
  title: string;
  language: ProgrammingLanguage;
  description: string;
  difficulty: DifficultyLevel;
  is_published: boolean;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface Chapter {
  id: string;
  course_id: string;
  slug: string;
  title: string;
  description: string;
  sort_order: number;
  is_published: boolean;
  created_at: string;
  updated_at: string;
}

export interface LessonSource {
  id: string;
  lesson_id: string;
  source_name: string;
  source_url: string;
  programming_language: ProgrammingLanguage;
  version: string;
  last_verified_date: string;
  verification_status: VerificationStatus;
  notes: string;
}

export interface Lesson {
  id: string;
  course_id: string;
  chapter_id: string;
  slug: string;
  title: string;
  summary: string;
  content_markdown: string;
  code_example: string;
  code_explanation: string;
  common_mistakes: string;
  key_takeaways: string;
  language: ProgrammingLanguage;
  language_version: string;
  difficulty: DifficultyLevel;
  estimated_minutes: number;
  sort_order: number;
  is_published: boolean;
  verification_status: VerificationStatus;
  last_verified_at: string | null;
  created_at: string;
  updated_at: string;
  lesson_sources?: LessonSource[];
}

export interface PublicExercise {
  id: string;
  lesson_id: string;
  title: string;
  type: ExerciseType;
  instructions: string;
  language: ProgrammingLanguage;
  starter_code: string;
  sample_input: string;
  sample_output: string;
  pass_threshold: number;
  time_limit_ms: number;
  memory_limit_kb: number;
  is_required: boolean;
  sort_order: number;
}

export interface PublicTestCase {
  id: string;
  exercise_id: string;
  name: string;
  input_data: string;
  expected_output: string;
  is_hidden: boolean;
  sort_order: number;
}

export interface PublicQuizOption {
  id: string;
  question_id: string;
  option_label: "A" | "B" | "C" | "D";
  option_text: string;
}

export interface PublicQuizQuestion {
  id: string;
  exercise_id: string;
  question_text: string;
  sort_order: number;
  options: PublicQuizOption[];
}

export interface LessonProgress {
  id: string;
  user_id: string;
  course_id: string;
  lesson_id: string;
  lesson_completed: boolean;
  exercise_completed: boolean;
  best_coding_score: number;
  best_quiz_score: number;
  attempts_count: number;
  time_spent_seconds: number;
  last_accessed_at: string;
  completed_at: string | null;
}

export interface TestCaseExecutionResult {
  testCaseId: string;
  name: string;
  isHidden: boolean;
  passed: boolean;
  status: string;
  stdout: string;
  stderr: string;
  expectedOutput?: string;
  actualOutput?: string;
  executionTimeMs: number | null;
  memoryKb: number | null;
}

export interface CodingEvaluationResponse {
  mode: "test" | "submit";
  configured: boolean;
  score: number;
  passed: boolean;
  passedTests: number;
  totalTests: number;
  results: TestCaseExecutionResult[];
  diagnostic?: {
    errorType: "compile_error" | "runtime_error" | "wrong_answer" | "time_limit" | null;
    lineNumber: number | null;
    errorMessage: string;
    explanation: string;
    hint: string;
  };
  submissionId?: string;
  attemptNumber?: number;
  lessonUnlocked?: boolean;
}

export interface QuizQuestionFeedback {
  questionId: string;
  selectedOptionId: string | null;
  isCorrect: boolean;
  correctOptionLabel: "A" | "B" | "C" | "D";
  explanation: string;
  commonMisconception: string;
}

export interface QuizEvaluationResponse {
  mode: "test" | "submit";
  score: number;
  correctCount: number;
  totalQuestions: number;
  passed: boolean;
  feedback: QuizQuestionFeedback[];
  attemptId?: string;
  attemptNumber?: number;
  lessonUnlocked?: boolean;
}
