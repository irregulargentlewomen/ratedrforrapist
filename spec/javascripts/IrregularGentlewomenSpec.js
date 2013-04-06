describe("IrregularGentlewomen", function() {
  beforeEach(function(){
    node = jasmine.createSpyObj('node', ['removeClass', 'addClass']);
    $ = jasmine.createSpy('jquery').andReturn(node);
  });
  describe('#pushPageState', function(){
    beforeEach(function(){
      IrregularGentlewomen.pageStates = [''];
      IrregularGentlewomen.pushPageState('new-state');
    });
    it('adds the page state to the end of the array', function() {
      expect(IrregularGentlewomen.pageStates).toEqual(['', 'new-state']);
    });
    it('removes the old page state from the body class', function() {
      expect(node.removeClass).toHaveBeenCalledWith('');
    });
    it('adds the new page state to the body class', function() {
      expect(node.addClass).toHaveBeenCalledWith('new-state');
    });
  });
  describe('#popPageState', function(){
    beforeEach(function(){
      IrregularGentlewomen.pageStates = ['', 'old-state'];
      IrregularGentlewomen.popPageState();
    });
    it('removes the page state from the end of the array', function() {
      expect(IrregularGentlewomen.pageStates).toEqual(['']);
    });
    it('removes the old page state from the body class', function() {
      expect(node.removeClass).toHaveBeenCalledWith('old-state');
    });
    it('adds the new page state to the body class', function() {
      expect(node.addClass).toHaveBeenCalledWith('');
    });
  });
});