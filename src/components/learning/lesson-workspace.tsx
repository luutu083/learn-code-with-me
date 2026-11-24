"use client";

import { useState } from "react";
import { CodingExerciseRunner } from "@/components/learning/code-editor";
import { QuizRunner } from "@/components/learning/quiz-runner";
import { AiAssistantPanel } from "@/components/learning/ai-assistant";
import { LessonTimeTracker } from "@/components/learning/lesson-time-tracker";
import type {
  PublicExercise,
  PublicQuizQuestion,
  PublicTestCase,
} from "@/types/database";

interface LessonWorkspaceProps {
  courseId: string;
  lessonId: string;
  lessonTitle: string;
  exercise: PublicExercise | null;
  visibleTestCases: PublicTestCase[];
  quizQuestions: PublicQuizQuestion[];
  exerciseCompleted: boolean;
  lessonContentSlot: React.ReactNode;
}

export function LessonWorkspace({
  courseId,
  lessonId,
  lessonTitle,
  exercise,
  visibleTestCases,
  quizQuestions,
  exerciseCompleted,
  lessonContentSlot,
}: LessonWorkspaceProps) {
  const [liveCode, setLiveCode] = useState(exercise?.starter_code || "");

  return (
    <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
      <LessonTimeTracker courseId={courseId} lessonId={lessonId} />

      <div className="min-w-0 space-y-6">
        {lessonContentSlot}

        <section id="exercise-section" className="scroll-mt-6">
          {exercise ? (
            exercise.type === "coding" ? (
              <CodingExerciseRunner
                exercise={exercise}
                visibleTestCases={visibleTestCases}
                initialCompleted={exerciseCompleted}
                onCodeChange={setLiveCode}
              />
            ) : (
              <QuizRunner
                exercise={exercise}
                questions={quizQuestions}
                initialCompleted={exerciseCompleted}
              />
            )
          ) : (
            <div className="rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-800">
              Bài học này chưa được gắn bài tập bắt buộc. Vui lòng liên hệ quản trị viên.
            </div>
          )}
        </section>
      </div>

      <aside className="xl:sticky xl:top-6 xl:self-start">
        <AiAssistantPanel
          lessonId={lessonId}
          lessonTitle={lessonTitle}
          currentCode={exercise?.type === "coding" ? liveCode : undefined}
        />
      </aside>
    </div>
  );
}
