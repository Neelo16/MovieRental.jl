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

function statement(customer::Customer)
    totalamount::Float64 = 0.0
    frequentrenterpoints = 0
    result = "Rental Record for $(customer.name)\n"
    for each in customer.rentals
        thisamount::Float64 = 0
        # determine amounts for each line
        if each.movie.pricecode == REGULAR
            thisamount += 2
            if each.daysrented > 2
                thisamount += (each.daysrented - 2) * 1.5
            end
        elseif each.movie.pricecode == NEW_RELEASE
            thisamount += each.daysrented * 3
        elseif each.movie.pricecode == CHILDRENS
            thisamount += 1.5
            if each.daysrented > 3
                thisamount += (each.daysrented - 3) * 1.5
            end
        end

        # add frequent renter points
        frequentrenterpoints += 1
        # add bonus for a two day new release rental
        if each.movie.pricecode == NEW_RELEASE && each.daysrented > 1
            frequentrenterpoints += 1
        end

        # show figures for this rental
        result *= "\t$(each.movie.title)\t$(thisamount)\n"
        totalamount += thisamount
    end
    # add footer lines
    result *= "Amount owed is $(totalamount)\n"
    result *= "You earned $(frequentrenterpoints) frequent renter points"
    return result
end
