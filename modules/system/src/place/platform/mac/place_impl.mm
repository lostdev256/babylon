#include <pch.h>

#include <Place/Platform/Mac/PlaceImpl.h>

namespace babylon::Place
{

    PlacePtr Place::CreateImpl()
    {
        return std::make_shared<Platform::PlaceImpl>();
    }

} // namespace babylon::Place

namespace babylon::Place::Platform
{

} // namespace babylon::Place::Platform
