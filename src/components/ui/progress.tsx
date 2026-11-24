import * as React from "react";
import { cn } from "@/lib/utils";

export function Progress({
  value = 0,
  className,
}: {
  value: number;
  className?: string;
}) {
  const clamped = Math.max(0, Math.min(100, Math.round(value)));
  return (
    <div className={cn("h-2.5 w-full overflow-hidden rounded-full bg-slate-200", className)}>
      <div
        className="h-full rounded-full bg-indigo-600 transition-all duration-300"
        style={{ width: `${clamped}%` }}
      />
    </div>
  );
}
