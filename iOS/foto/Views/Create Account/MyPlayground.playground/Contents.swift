import UIKit

var greeting = "Hello, playground"

class A {
    var bar: String
    init(bar: String) {
        self.bar = bar
    }
}

struct B {
    var bar: String
    init(bar: String) {
        self.bar = bar
    }
    init() {
        self.bar = ""
    }
}

//LET and VAR


let binstance = B(bar: "bob")
let aPointerOne = A(bar: "bob")

let aPointerTwo = aPointerOne
aPointerTwo.bar = ""

print(aPointerOne.bar)
//binstance.bar = ""
//ainstance.bar = ""
//ainstance = A(bar: "")

let array = ["a","b"]
var array2 = array
array2.append("")
print(array)
print(array2)


func changebar(_ inside:A) {
    inside.bar  = "John"
    inside = A(bar: "")
}

func changebar(_ instance:B) {
    instance.bar  = "John"
}


func wtf(lol: String = "")

wtf()
//changebar(ainstance)

//Int,String,Array,Dictionary,
