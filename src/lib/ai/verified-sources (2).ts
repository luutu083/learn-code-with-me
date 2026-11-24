import type { ProgrammingLanguage } from "@/types/database";

export interface TrustedSourceDefinition {
  id: string;
  language: ProgrammingLanguage;
  sourceName: string;
  sourceUrl: string;
  allowedDomain: string;
  version: string;
}

/**
 * Verified official documentation allowlist for the Anti-Hallucination Knowledge System.
 * Every URL here is an official primary documentation resource.
 */
export const TRUSTED_SOURCES: TrustedSourceDefinition[] = [
  {
    id: "gnu-c-manual",
    language: "c",
    sourceName: "The GNU C Reference Manual",
    sourceUrl: "https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html",
    allowedDomain: "www.gnu.org",
    version: "C11 / GNU C",
  },
  {
    id: "glibc-manual",
    language: "c",
    sourceName: "The GNU C Library (glibc) Manual",
    sourceUrl: "https://sourceware.org/glibc/manual/",
    allowedDomain: "sourceware.org",
    version: "glibc 2.x / ISO C",
  },
  {
    id: "gcc-onlinedocs",
    language: "c",
    sourceName: "GCC Online Documentation",
    sourceUrl: "https://gcc.gnu.org/onlinedocs/",
    allowedDomain: "gcc.gnu.org",
    version: "GCC 12+",
  },
  {
    id: "devdocs-c",
    language: "c",
    sourceName: "C Standard Library Reference (DevDocs / cppreference)",
    sourceUrl: "https://devdocs.io/c/",
    allowedDomain: "devdocs.io",
    version: "ISO C11/C17",
  },
  {
    id: "python-tutorial",
    language: "python",
    sourceName: "The Python Tutorial — Official Python Documentation",
    sourceUrl: "https://docs.python.org/3/tutorial/index.html",
    allowedDomain: "docs.python.org",
    version: "Python 3.x",
  },
  {
    id: "python-stdlib",
    language: "python",
    sourceName: "The Python Standard Library — Official Python Documentation",
    sourceUrl: "https://docs.python.org/3/library/index.html",
    allowedDomain: "docs.python.org",
    version: "Python 3.x",
  },
  {
    id: "python-reference",
    language: "python",
    sourceName: "The Python Language Reference — Official Python Documentation",
    sourceUrl: "https://docs.python.org/3/reference/index.html",
    allowedDomain: "docs.python.org",
    version: "Python 3.x",
  },
  {
    id: "python-pep8",
    language: "python",
    sourceName: "PEP 8 – Style Guide for Python Code",
    sourceUrl: "https://peps.python.org/pep-0008/",
    allowedDomain: "peps.python.org",
    version: "Python 3.x",
  },
];

const TRUSTED_DOMAINS_BY_LANG: Record<ProgrammingLanguage, string[]> = {
  c: ["www.gnu.org", "sourceware.org", "gcc.gnu.org", "devdocs.io", "en.cppreference.com", "cppreference.net", "iso-9899.info"],
  python: ["docs.python.org", "peps.python.org", "www.python.org", "pypi.org", "github.com"],
};

export function isTrustedSourceUrl(language: ProgrammingLanguage, rawUrl: string): boolean {
  try {
    const parsed = new URL(rawUrl);
    if (parsed.protocol !== "https:" && parsed.protocol !== "http:") {
      return false;
    }
    const allowed = TRUSTED_DOMAINS_BY_LANG[language] || [];
    return allowed.some((domain) => parsed.hostname === domain || parsed.hostname.endsWith(`.${domain}`));
  } catch {
    return false;
  }
}

export function getTrustedSourcesForLanguage(language: ProgrammingLanguage): TrustedSourceDefinition[] {
  return TRUSTED_SOURCES.filter((s) => s.language === language);
}
