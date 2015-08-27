sysPath = require('path')
fs = require('fs')

describe 'Plugin', ->
  
  plugin = null

  beforeEach ->
    plugin = new Plugin(paths: root: '.');

  it 'should be an object', ->
    expect(plugin).to.be.ok

  it 'should has #compile method', ->
    expect(plugin.compile).to.be.an.instanceof(Function)

  it 'should compile and produce valid result', (done)->
    content = fs.readFileSync(sysPath.join(__dirname,"./TestComponent.cjsx"), "utf8")
    expectedResult = """var React, TestComponent;

React = require("react");

module.exports = TestComponent = React.createClass({
  render: function() {
    return React.createElement("h1", null, "Hello React");
  }
});\n
"""

    plugin.compile content, "TestComponent", (error, result)->
      expect(error).not.to.be.ok
      expect(result).to.equal(expectedResult)
      done()