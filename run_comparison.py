import subprocess
import sys

VERSIONS = [
    ("flix070.jar", "0.70", "results_v070.txt"),
    ("flix072.jar",  "0.72", "results_v072.txt"),
]

SRC = [
    "src/Main.flix",
    "src/Csv.flix",
    "src/Road.flix",
    "src/Runner.flix",
]


def run_benchmark(jar, version, outfile):
    print(f"Running Flix {version} ({jar})...", flush=True)
    result = subprocess.run(
        ["java", "-jar", jar] + SRC,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        timeout=600,
    )
    output = result.stdout
    if result.stderr.strip():
        output += "\n--- stderr ---\n" + result.stderr
    with open(outfile, "w", encoding="utf-8") as f:
        f.write(output)
    if result.returncode != 0:
        print(f"  ERROR: exit code {result.returncode}. Check {outfile} for details.")
        sys.exit(1)
    print(f"  Done. Output saved to {outfile}.")


def main():
    for jar, version, outfile in VERSIONS:
        run_benchmark(jar, version, outfile)
    print("\nAll runs complete.")


if __name__ == "__main__":
    main()
