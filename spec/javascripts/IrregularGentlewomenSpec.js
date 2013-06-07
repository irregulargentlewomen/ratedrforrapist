describe("IrregularGentlewomen", function() {
  var node = null;
  beforeEach(function(){
    node = jasmine.createSpyObj('node',
      ['removeClass', 'addClass', 'html', 'append']
    );
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

  describe('#populateDisambiguator', function() {
    beforeEach(function() {
      IrregularGentlewomen.populateDisambiguator([
        {id: 43, title: 'test'}
      ]);
    });
    it('targets the correct node', function() {
      expect($).toHaveBeenCalledWith('.disambiguation ul');
    });
    it('correctly populates the list', function() {
      expect(node.append).toHaveBeenCalledWith(
        '<li><a href="/search?id=43">test</a></li>'
      );
    })
  });

  describe('#populateBlacklist', function() {
    beforeEach(function() {
      IrregularGentlewomen.populateBlacklist([
        {
          name: "Helena Bonham Carter",
          role: 'Mrs. Lovett',
          id: 550,
          blacklist_roles: [
            {
              movie: {title: 'Harry Potter', release_year: '2000'},
              role: 'Bellatrix Lestrange'
            },
            {
              movie: null,
              role: 'petitioner'
            }
          ]
        }
      ]);
    });
    it('targets the correct node', function() {
      expect($).toHaveBeenCalledWith('.positive.response ul');
    });
    it('correctly populates the list', function() {
      expect(node.append).toHaveBeenCalledWith(
        '<li id="person-550">' +
          '<h3><a href="#person-550">' +
            'Helena Bonham Carter (Mrs. Lovett)' +
          '</a></h3>' +
          '<p>Harry Potter (2000) &mdash; Bellatrix Lestrange</p>' +
          '<p>petitioner</p>' +
        '</li>'
      );
    })
  });

  describe('#clearBlackist', function() {
    it('clears the blacklist', function() {
      IrregularGentlewomen.clearBlacklist();
      expect(node.html).toHaveBeenCalledWith('');
    });
  });

  describe('#populateList', function() {
    beforeEach(function() {
      IrregularGentlewomen.populateList('section', ['test'], function(x) {
        return '-' + x + '-';
      });
    });

    it('targets the correct node', function() {
      expect($).toHaveBeenCalledWith('section ul');
    });

    it('correctly populates the list', function() {
      expect(node.append).toHaveBeenCalledWith('-test-');
    });
  });

  describe('#setMovieTitle', function() {
    beforeEach(function() {
      IrregularGentlewomen.setMovieTitle('new title');
    });
    it('sets the movie title', function() {
      expect(node.html).toHaveBeenCalledWith('new title');
    });
    it('targets the correct node', function() {
      expect($).toHaveBeenCalledWith('.movie-title');
    });
  });
});