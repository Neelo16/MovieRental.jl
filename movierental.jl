@enum PriceCode REGULAR CHILDRENS NEW_RELEASE

struct Movie
    title::String
    pricecode::PriceCode
end

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

function amountfor(rental)
    result::Float64 = 0
    if rental.movie.pricecode == REGULAR
        result += 2
        if rental.daysrented > 2
            result += (rental.daysrented - 2) * 1.5
        end
    elseif rental.movie.pricecode == NEW_RELEASE
        result += rental.daysrented * 3
    elseif rental.movie.pricecode == CHILDRENS
        result += 1.5
        if rental.daysrented > 3
            result += (rental.daysrented - 3) * 1.5
        end
    end
    return result
end

function getFrequentRenterPoints(rental)
    frequentrenterpoints = 1
    if rental.movie.pricecode == NEW_RELEASE && rental.daysrented > 1
        frequentrenterpoints += 1
    end
    return frequentrenterpoints
end

getTotalFrequentRenterPoints(customer) = sum(map(getFrequentRenterPoints, customer.rentals))

function statement(customer::Customer)
    result = "Rental Record for $(customer.name)\n"
    for each in customer.rentals
        # show figures for this rental
        result *= "\t$(each.movie.title)\t$(amountfor(each))\n"
    end
    # add footer lines
    result *= "Amount owed is $(sum(map(amountfor, customer.rentals)))\n"
    result *= "You earned $(getTotalFrequentRenterPoints(customer)) frequent renter points"
    return result
end
