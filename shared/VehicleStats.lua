local VehicleStats = {
    city_hatchback = {
        Name = "City Hatchback",
        Price = 15000,
        MaxSpeed = 90,
        Acceleration = 0.4,
        Handling = 0.7,
    },
    sport_coupe = {
        Name = "Sport Coupe",
        Price = 50000,
        MaxSpeed = 140,
        Acceleration = 0.65,
        Handling = 0.6,
    },
    luxury_sedan = {
        Name = "Luxury Sedan",
        Price = 80000,
        MaxSpeed = 130,
        Acceleration = 0.55,
        Handling = 0.75,
    },
    offroad_suv = {
        Name = "Offroad SUV",
        Price = 60000,
        MaxSpeed = 110,
        Acceleration = 0.5,
        Handling = 0.8,
    },
    hypercar = {
        Name = "Hypercar",
        Price = 200000,
        MaxSpeed = 200,
        Acceleration = 0.9,
        Handling = 0.55,
    },
}

function VehicleStats.Get(id)
    return VehicleStats[id]
end

return VehicleStats
