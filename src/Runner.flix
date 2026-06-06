mod Runner {
    use Sys.Console
    use Time.{Clock, TimeUnit}

    def forceEval(x: Vector[a]): Unit \ Console =
        if (Vector.length(x) == -1)
            Console.println("")
        else ()

    pub def runTimed(solv: Unit -> Vector[a] \ ef): Int64 \ ef + Console + Clock =
        let result = solv();
        let t0 = Clock.currentTime(TimeUnit.Nanoseconds);
        forceEval(result);
        let t1 = Clock.currentTime(TimeUnit.Nanoseconds);
        t1 - t0

}
