
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const hre = require("hardhat")

describe("MyToken contract", function () {

  let Token
  let myToken
  let owner
  let addr1
  let addr2

 
  beforeEach (async function () {

    Token = await ethers.getContractFactory("MyToken");
    [owner, addr1, addr2] = await hre.ethers.getSigners();

    myToken = await Token.deploy(50)
  })
  
  describe("Deployment", function () {
    it("Should set the right owner", async function() {
      expect(await myToken.owner()).to.equal(owner.address)
    })
    it("Should get 50 tokens because of constructor amount is 50",async function() {
      const ownerBalance = await myToken.balanceOf(owner.address)
      expect(await myToken.totalSupply()).to.equal(ownerBalance)
    })

    it("Should set the new minter that can mint token", async function() {
      // const minterByOwner = await owner.myToken._addMinter(addr1)
      const minterByOwner = await myToken.connect(owner)._addMinter(addr1.address)
      const mint = await myToken.connect(addr1)._mint(addr2.address, 100)
      expect(await myToken.balanceOf(addr2.address)).to.equal(100)
      // expect(myToken.onlyMinter(addr1)).to.equal(true)
    })
    
  })
});