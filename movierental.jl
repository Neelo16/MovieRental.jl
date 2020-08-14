@enum PriceCode REGULAR CHILDRENS NEW_RELEASE

abstract type Price end
struct RegularPrice <: Price end
struct ChildrensPrice <: Price end
struct NewReleasePrice <: Price end

function Price(pricecode)
    if pricecode == REGULAR
        price = RegularPrice()
    elseif pricecode == CHILDRENS
        price = ChildrensPrice()
    elseif pricecode == NEW_RELEASE
        price = NewReleasePrice()
    else
        error("Incorrect Price Code")
    end
    return price
end
pricecode(::RegularPrice) = REGULAR
pricecode(::ChildrensPrice) = CHILDRENS
pricecode(::NewReleasePrice) = NEW_RELEASE

mutable struct Movie
    title::String
    price::Price
end

function Movie(title::String, pricecode::PriceCode)
    Movie(title, Price(pricecode))
end
setprice(movie::Movie, pricecode::PriceCode) = movie.price = Price(pricecode)
Base.getproperty(m::Movie, s::Symbol) = s == :pricecode ? pricecode(m.price) : getfield(m, s)

struct Rental
    movie::Movie
    daysrented::Int
end

struct Customer
    name::String
    rentals::Vector{Rental}
end
Customer(name::String) = Customer(name, [])
addrental(c::Customer, r::Rental) = push!(c.rentals, r)

function getCharge(::RegularPrice, daysrented::Int)
    result::Float64 = 2
    if daysrented > 2
        result += (daysrented - 2) * 1.5
    end
    return result
end

getCharge(::NewReleasePrice, daysrented::Int)::Float64 = return daysrented * 3

function getCharge(::ChildrensPrice, daysrented::Int)
    result = 1.5
    if daysrented > 3
        result += (daysrented - 3) * 1.5
    end
    return result
end

function getCharge(price::Price, daysrented::Int)
    error("Price charge not implemented")
end

getCharge(rental::Rental) = getCharge(rental.movie.price, rental.daysrented)

function getFrequentRenterPoints(rental)
    frequentrenterpoints = 1
    if rental.movie.pricecode == NEW_RELEASE && rental.daysrented > 1
        frequentrenterpoints += 1
    end
    return frequentrenterpoints
end

getTotalFrequentRenterPoints(customer) = sum(map(getFrequentRenterPoints, customer.rentals))

getTotalCharge(customer) = sum(map(getCharge, customer.rentals))

function statement(customer::Customer)
    result = "Rental Record for $(customer.name)\n"
    for each in customer.rentals
        # show figures for this rental
        result *= "\t$(each.movie.title)\t$(getCharge(each))\n"
    end
    # add footer lines
    result *= "Amount owed is $(getTotalCharge(customer))\n"
    result *= "You earned $(getTotalFrequentRenterPoints(customer)) frequent renter points"
    return result
end
