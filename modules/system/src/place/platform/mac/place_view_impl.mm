#include <pch.h>

#include <Place/Platform/Mac/PlaceViewImpl.h>

namespace babylon::Place
{

    PlaceViewPtr PlaceView::CreateImpl()
    {
        return std::make_shared<Platform::PlaceViewImpl>();
    }

} // namespace babylon::Place

namespace babylon::Place::Platform
{

bool PlaceViewImpl::Create()
{
    return true;
}

} // namespace babylon::Place::Platform
