const PaymentRouter = artifacts.require("PaymentRouter");

contract('PaymentRouter', (accounts) => {
  it('should price > 0', async () => {
    const priceRouterInstance = await PaymentRouter.at("0x2D06f4240DC7F27FbDf4A9Dcc041401bF9307Bf1");
    const price = await priceRouterInstance.price.call(1);
    console.log("price = ", price.valueOf());
    assert.equal(price.valueOf(), 100, "price not equal 100");
  });
  
});
