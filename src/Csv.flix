mod Csv {
    use Fs.{FileRead, FileWrite, WriteLines}
    use Math.Shuffle

    pub def readRows(
        f: { filename = String },
        del: { delimiter = String }
    ): Result[String, List[List[String]]] \ FileRead =
        FileRead.readLines(f#filename)
            |> Result.mapErr(_ -> "No such file: ${f#filename}")
            |> Result.map(List.map(x -> String.split(regex = del#delimiter, x)))

    pub def sampleFile(filename: String, n: Int32): Result[IoError, Unit] \ FileRead + WriteLines + Shuffle =
        forM (
            lines <- FileRead.readLines(filename);
            sampled = List.shuffle(lines) |> List.take(n);
            _ <- WriteLines.writeLines(lines = sampled, outputFilename(filename, n))
        ) yield ()

    def outputFilename(filename: String, n: Int32): String =
        match String.split(regex = "\\.", filename) {
            case base :: ext :: Nil => "${base}-${n}.${ext}"
            case _ => "${filename}-${n}"
        }

}
