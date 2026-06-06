use Fs.{FileWrite, FileRead, WriteLines}
use Math.Shuffle
use Sys.{Env, Console}
use Time.Clock

pub def main(): Unit \ IO = run {
    benchmark()
} with FileRead.runWithIO
  with Env.runWithIO
  with Clock.runWithIO
  with Console.runWithIO

pub def benchmark(): Unit \ Console + Clock + FileRead + Env =
    Console.println("Loading Road facts...");
    match Road.getFacts() {
        case Err(e)    => Console.println("Error: ${e}")
        case Ok(facts) =>
            Console.println("Loaded road facts.");
            Console.println("");
            let solv = () -> Road.solv(facts);
            let warmupRuns = 2;
            let measuredRuns = 5;
            Console.println("Warming up (${warmupRuns} runs, not measured)...");
            warmup(solv, warmupRuns);
            Console.println("Measuring (${measuredRuns} runs)...");
            let times = measure(solv, measuredRuns);
            Console.println("");
            printSummary("Road (1.5M edges)", times)
    }

pub def sample(): Unit \ IO + NonDet = run {
    match Csv.sampleFile("data/road/road.csv", 1_500_000) {
        case Err(e) => Console.println("Error: ${e}")
        case Ok(()) => Console.println("Done")
    }
} with FileRead.runWithIO
  with WriteLines.runWithFileWrite
  with FileWrite.runWithIO
  with Console.runWithIO
  with Shuffle.runWithIO

def warmup(solv: Unit -> Vector[a], n: Int32): Unit \ Console + Clock =
    if (n > 0) {
        discard Runner.runTimed(solv);
        warmup(solv, n - 1)
    }

def measure(solv: Unit -> Vector[a], n: Int32): List[Int64] \ Console + Clock =
    if (n <= 0) Nil
    else Runner.runTimed(solv) :: measure(solv, n - 1)

def printSummary(name: String, times: List[Int64]): Unit \ Console =
    let n = List.length(times);
    let total = List.foldLeft((acc, t) -> acc + t, 0i64, times);
    let avg = total / Int32.toInt64(n);
    let sorted = List.sort(times);
    let minT = match List.head(sorted) { case Some(t) => t case None => 0i64 };
    let maxT = match List.last(sorted) { case Some(t) => t case None => 0i64 };
    Console.println("Program:  ${name}");
    Console.println("Runs:     ${n}");
    Console.println("");
    Console.println("         ${String.padLeft(10, ' ', "ms")}");
    Console.println("         ${String.repeat(10, "-")}");
    printRow("Min", minT);
    printRow("Avg", avg);
    printRow("Max", maxT);
    Console.println("")

def printRow(label: String, ns: Int64): Unit \ Console =
    let ms = ns / 1_000_000i64;
    Console.println("${String.padRight(9, ' ', label)}${String.padLeft(10, ' ', Int64.toString(ms))}")
