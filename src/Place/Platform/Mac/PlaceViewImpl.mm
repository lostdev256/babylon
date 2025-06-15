#include <pch.h>

#include <Place/Platform/Mac/PlaceViewImpl.h>

namespace BN::Place
{

    PlaceViewPtr PlaceView::CreateImpl()
    {
        return std::make_shared<Platform::PlaceViewImpl>();
    }

} // namespace BN::Place

namespace BN::Place::Platform
{

bool PlaceViewImpl::Create()
{
    return true;
}

} // namespace BN::Place::Platform
