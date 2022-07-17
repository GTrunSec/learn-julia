a = 1 + 2
b = "s"

abstract type Animal end
struct Fox <: Animal
    weight::Float64
end
struct Chicken <: Animal
    weight::Float64
end

fiona = Fox(4.2)
big_bird = Chicken(2.9)

combined_weight(A1::Animal, A2::Animal) = A1.weight + A2.weight

combined_weight(Chicken(4.2),Fox(3.0))


function naive_trouble(A::Animal, B::Animal)
    if A isa Fox && B isa Chicken
        return true
    elseif A isa Chicken && B isa Fox
        return true
    elseif A isa Chicken && B isa Chicken
        return false
    end
end

naive_trouble(big_bird,fiona)
