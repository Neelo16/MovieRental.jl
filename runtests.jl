using Test

include("movierental.jl")

@testset "Movie Rental" begin

    let c = Customer("John"),
        m = Movie("Gone with the Wind", REGULAR),
        r = Rental(m, 3)
        addrental(c, r)
        @test statement(c) == "Rental Record for John\n" *
                              "\tGone with the Wind\t3.5\n" *
                              "Amount owed is 3.5\n" *
                              "You earned 1 frequent renter points"
    end

    let c = Customer("David"),
        m = Movie("Star Wars", NEW_RELEASE),
        r = Rental(m, 3)
        addrental(c, r)
        @test statement(c) == "Rental Record for David\n" *
                              "\tStar Wars\t9.0\n" *
                              "Amount owed is 9.0\n" *
                              "You earned 2 frequent renter points"
    end

    let c = Customer("Sally"),
        m = Movie("Madagascar", CHILDRENS),
        r = Rental(m, 3)
        addrental(c, r)
        @test statement(c) == "Rental Record for Sally\n" *
                              "\tMadagascar\t1.5\n" *
                              "Amount owed is 1.5\n" *
                              "You earned 1 frequent renter points"
    end

    let c = Customer("Tony"),
        m = Movie("Madagascar", CHILDRENS),
        r = Rental(m, 6),
        m2 = Movie("Star Wars", NEW_RELEASE),
        r2 = Rental(m2, 2),
        m3 = Movie("Gone with the Wind", REGULAR),
        r3 = Rental(m3, 8)
        addrental(c, r)
        addrental(c, r2)
        addrental(c, r3)
        @test statement(c) == "Rental Record for Tony\n" *
                              "\tMadagascar\t6.0\n" *
                              "\tStar Wars\t6.0\n" *
                              "\tGone with the Wind\t11.0\n" *
                              "Amount owed is 23.0\n" *
                              "You earned 4 frequent renter points"
    end
end
