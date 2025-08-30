# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-src"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-build"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/tmp"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src"
  "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp"
)

set(configSubDirs Debug)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/flutter/Nyat Ride System/nyat_ride_system/Passenger_Mobile_App/build/windows/x64/_deps/nuget-subbuild/nuget-populate-prefix/src/nuget-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
