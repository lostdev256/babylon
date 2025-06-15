#include <pch.h>

#include <Place/Platform/Mac/PlaceImpl.h>

namespace BN::Place
{

    PlacePtr Place::CreateImpl()
    {
        return std::make_shared<Platform::PlaceImpl>();
    }

} // namespace BN::Place

namespace BN::Place::Platform
{

} // namespace BN::Place::Platform
