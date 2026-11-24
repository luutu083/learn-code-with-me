"use client";

import { useEffect } from "react";

export function LessonTimeTracker({
  courseId,
  lessonId,
}: {
  courseId: string;
  lessonId: string;
}) {
  useEffect(() => {
    const interval = setInterval(() => {
      if (document.visibilityState === "visible") {
        fetch("/api/progress", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ courseId, lessonId, deltaSeconds: 30 }),
        }).catch(() => {});
      }
    }, 30_000);

    return () => clearInterval(interval);
  }, [courseId, lessonId]);

  return null;
}
