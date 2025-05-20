listView('testlist') {
    description('All new jobs for testlist')
    filterBuildQueue()
    filterExecutors()
    jobs {
        name('fruit')
        name('cake')

    }
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
}