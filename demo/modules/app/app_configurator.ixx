export module app:app_configurator;

import babylon.system

export namespace app
{

class app_configurator final : public babylon::system::app_configurator_iface
{
public:
    void configure() override;
};

} // namespace app
