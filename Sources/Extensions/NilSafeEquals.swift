////
///  NilSafeEquals.swift
//

infix operator =?= {
    associativity none
    precedence 130
}
func =?= <T where T: Equatable>(lhs: Optional<T>, rhs: Optional<T>) -> Bool {
    guard let
        lhs = lhs,
        rhs = rhs
    else {
        return false
    }
    return lhs == rhs
}
func =?= <T where T: Equatable>(lhs: T, rhs: Optional<T>) -> Bool {
    guard let
        rhs = rhs
    else {
        return false
    }
    return lhs == rhs
}
func =?= <T where T: Equatable>(lhs: Optional<T>, rhs: T) -> Bool {
    guard let
        lhs = lhs
    else {
        return false
    }
    return lhs == rhs
}
func =?= <T where T: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs == rhs
}
