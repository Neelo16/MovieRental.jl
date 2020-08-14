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

function getFrequentRenterPoints(each, frequentrenterpoints)
    frequentrenterpoints += 1
    if each.movie.pricecode == NEW_RELEASE && each.daysrented > 1
        frequentrenterpoints += 1
    end
    return frequentrenterpoints
end

function statement(customer::Customer)
    totalamount::Float64 = 0.0
    frequentrenterpoints = 0
    result = "Rental Record for $(customer.name)\n"
    for each in customer.rentals
        thisamount = amountfor(each)

        # add frequent renter points
        frequentrenterpoints = getFrequentRenterPoints(each, frequentrenterpoints)

        # show figures for this rental
        result *= "\t$(each.movie.title)\t$(thisamount)\n"
        totalamount += thisamount
    end
    # add footer lines
    result *= "Amount owed is $(totalamount)\n"
    result *= "You earned $(frequentrenterpoints) frequent renter points"
    return result
end
