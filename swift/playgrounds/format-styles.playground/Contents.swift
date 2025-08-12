import Foundation

Double(100_000_000_000).formatted(
    .number
        .notation(.automatic)
        .grouping(.automatic)
)
