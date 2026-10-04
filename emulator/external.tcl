after realtime 0.5 {
    foreach source {{External V9968} V9968} {
        if {![catch {set videosource $source}]} {break}
    }
}
