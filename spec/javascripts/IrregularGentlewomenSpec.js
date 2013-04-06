describe("IrregularGentlewomen", function() {
  beforeEach(function(){
    $ = jasmine.createSpy('jquery').
      andReturn(jasmine.createSpyObj('node', ['removeClass', 'addClass']));
  });
  describe('#pushPageState', function(){
    it('adds the page state to the end of the array', function() {
      IrregularGentlewomen.pageStates = [''];
      IrregularGentlewomen.pushPageState('new-state');
      expect(IrregularGentlewomen.pageStates).toEqual(['', 'new-state']);
    }); 
  });
});