mod Road {
    use Csv.readRows
    use Fs.FileRead
    use Sys.Env

    def dataFile(): String = "data/road/road-1500000.csv"

    pub def getFacts(): Result[String, #{ Road(Int64, Int64) | r }] \ Env + FileRead =
        let parseRow = row -> match row {
            case src :: dst :: Nil => match (Int64.fromString(src), Int64.fromString(dst)) {
                case (Some(s), Some(d)) => Ok((s, d))
                case _ => Err("Error parsing integer in road data")
            }
            case _ => Err("Unexpected column count in road data")
        };
        forM (
            cwd <- Env.getCurrentWorkingDirectory() |> Option.toOk("Could not get cwd");
            tuples <- readRows(filename = "${cwd}/${dataFile()}", delimiter = " ");
            roads  <- Result.traverse(parseRow, tuples)
        ) yield inject roads into Road/2

    pub def solv(facts: #{ Road(Int64, Int64) }): Vector[(Int64, Int64)] =
        let rules = #{
            Path(x, y) :- Road(x, y).
            Path(x, z) :- Path(x, y), Road(y, z).
        };
        query facts, rules select (x, y) from Path(x, y)

}
