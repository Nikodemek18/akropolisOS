import { CoreContract, CoreInstance} from "../types/truffle-contracts/index";
// tslint:disable-next-line:no-var-requires
const { BN, constants, expectEvent, shouldFail } = require("@openzeppelin/test-helpers");
// tslint:disable-next-line:no-var-requires
const should = require("chai").should();

const Core = artifacts.require("Core");

contract("CoreFactory", async ([_, owner,  wallet1, wallet2, wallet3, wallet4, wallet5]) => {
    let pool: CoreInstance;
  
    beforeEach(async () => {
        pool = await Core.new();
        await pool.initialize();
        await pool.setMetadata("creditPool", "Great Pool");
    });

    it("should have proper owner", async () => {
        const address = await pool.owner();
        (await pool.founder()).should.equal(address);
    });
    
    it("should have proper name", async () => {
        (await pool.name()).should.equal("creditPool");
    });

    it("should have  proper description", async () => {
        (await pool.description()).should.equal("Great Pool");
    });
});