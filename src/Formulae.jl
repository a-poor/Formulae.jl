
#=
* Overload `display`
* Overload `[+,-,*,/,^]` for `AbstractValue`s
* Update variable values in `Operation`s
* Create `Formula`, set one side equal to another 
=#


module Formulae


import Base: +, -, *, /, ^, display, string

export 
    Variable, Constant,
    UnaryOperator, BinaryOperator,
    UnaryOperation, BinaryOperation,
    Negate, Add, Subtract, Multiply, Divide,
    getval,
    +, -, *, /, ^, display, string

abstract type AbstractValue end

mutable struct Variable{T<:Number} <: AbstractValue
    name::String
    value::T
end

Variable() = Variable("x")
Variable(name::String) = Variable(name,0)


function string(v::Variable)
    "{$(v.name)=$(v.value)}"
end
display(v::Variable) = println(string(v))


mutable struct Constant{T<:Number} <: AbstractValue
    value::T
end

Constant() = Constant(0)

function string(c::Constant)
    "{$(c.value)}"
end
display(c::Constant) = println(string(c))

abstract type AbstractOperator end

struct UnaryOperator <: AbstractOperator 
    name::String
    func::Function
end

function string(op::UnaryOperator)
    "{$(op.name)}"
end
display(op::UnaryOperator) = println(string(op))

struct BinaryOperator <: AbstractOperator 
    name::String
    func::Function
end

function string(op::BinaryOperator)
    "{$(op.name)}"
end
display(op::BinaryOperator) = println(string(op))

Negate   = UnaryOperator("-", -)

Add      = BinaryOperator("+", +)
Subtract = BinaryOperator("-", -)
Multiply = BinaryOperator("*", *)
Divide   = BinaryOperator("/", /)
Power    = BinaryOperator("^", ^)


abstract type AbstractOperation end


struct UnaryOperation <: AbstractOperation
    op::UnaryOperator
    arg::Union{AbstractValue,AbstractOperation}
end

struct BinaryOperation <: AbstractOperation
    op::BinaryOperator
    left::Union{AbstractValue,AbstractOperation}
    right::Union{AbstractValue,AbstractOperation}
end


function string(op::UnaryOperation)
    "{$(string(op.op)) $(string(op.arg))}"
end
display(op::UnaryOperation) = println(string(op))

function string(op::BinaryOperation)
    "{$(string(op.left)) $(string(op.op)) $(string(op.right))}"
end
display(op::BinaryOperation) = println(string(op))



function -(a::Union{AbstractValue,AbstractOperation})
    UnaryOperation(Negate, a)
end

function +(a::Union{AbstractValue,AbstractOperation}, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Add, a, b)
end

function +(a::Number, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Add, Constant(a), b)
end

function +(a::Union{AbstractValue,AbstractOperation}, b::Number)
    BinaryOperation(Add, a, Constant(b))
end

function -(a::Union{AbstractValue,AbstractOperation}, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Subtract, a, b)
end

function -(a::Number, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Subtract, Constant(a), b)
end

function -(a::Union{AbstractValue,AbstractOperation}, b::Number)
    BinaryOperation(Subtract, a, Constant(b))
end

function *(a::Union{AbstractValue,AbstractOperation}, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Multiply, a, b)
end

function *(a::Number, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Multiply, Constant(a), b)
end

function *(a::Union{AbstractValue,AbstractOperation}, b::Number)
    BinaryOperation(Multiply, a, Constant(b))
end

function /(a::Union{AbstractValue,AbstractOperation}, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Divide, a, b)
end

function /(a::Number, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Divide, Constant(a), b)
end

function /(a::Union{AbstractValue,AbstractOperation}, b::Number)
    BinaryOperation(Divide, a, Constant(b))
end

function ^(a::Union{AbstractValue,AbstractOperation}, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Power, a, b)
end

function ^(a::Number, b::Union{AbstractValue,AbstractOperation})
    BinaryOperation(Power, Constant(a), b)
end

function ^(a::Union{AbstractValue,AbstractOperation}, b::Number)
    BinaryOperation(Power, a, Constant(b))
end



function getval(v::AbstractValue)
    v.value
end

function getval(o::UnaryOperation)
    o.op.func(getval(o.arg))
end

function getval(o::BinaryOperation)
    o.op.func(getval(o.left), getval(o.right))
end


function update!(v::Variable, data::Dict{String,Number})
    if v.name in keys(data)
        v.value = data[v.name]
    end
    nothing
end

function update!(o::UnaryOperation, data::Dict{String,Number})
    update!(o.arg, data)
    nothing
end

function update!(o::BinaryOperation, data::Dict{String,Number})
    update!(o.left, data)
    update!(o.right, data)
    nothing
end


end # module

