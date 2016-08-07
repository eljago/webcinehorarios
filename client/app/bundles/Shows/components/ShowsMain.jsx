'use strict';

import React, { PropTypes } from 'react';

import PageHeader from 'react-bootstrap/lib/PageHeader';
import Button from 'react-bootstrap/lib/Button';
import Image from 'react-bootstrap/lib/Image';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pagination from 'react-bootstrap/lib/Pagination';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import InputGroup from 'react-bootstrap/lib/InputGroup';

// Simple example of a React "smart" component
export default class ShowsMain extends React.Component {
  static propTypes = {
    page: PropTypes.number.isRequired,
    showsPerPage: PropTypes.number.isRequired,
    shows: PropTypes.object.isRequired,
    hrefs: PropTypes.array.isRequired,
    showsCount: PropTypes.number.isRequired,
    handleEdit: PropTypes.func.isRequired,
    onChangePage: PropTypes.func,
    onSearchShow: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      ...this._getNewPaginatorState(props.showsCount, props.showsPerPage),
      searchValue: '',
    };
    _.bindAll(this, [
      '_onSearch',
      '_handleSearchInputChange',
      '_onResetSearchText'
    ]);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      ...this._getNewPaginatorState(nextProps.showsCount, nextProps.showsPerPage),
    });
  }

  _getNewPaginatorState(showsCount, showsPerPage) {
    const newItems = Math.ceil(showsCount / showsPerPage);
    return {
      items: newItems
    };
  }

  render() {
    const {shows, hrefs} = this.props;
    const tableRows = shows.map((show, i) => {
      const href = hrefs.get(i);
      return(
        <Row key={`${this.props.page}-${i}`}>
          <Col xs={1} md={1} lg={1}>{show.get('id')}</Col>
          <Col xs={3} md={2} lg={2}><Image src={`http://cinehorarios.cl${show.getIn(['image', 'smallest', 'url'])}`} /></Col>
          <Col xs={6} md={7} lg={7} fluid={true}>{show.get('name')}</Col>
          <Col xs={2} md={2} lg={2}>
            <Button href={href.get('edit')}>Editar</Button>
          </Col>
        </Row>
      );
    });

    return (
      <div className="container">
        <PageHeader>Shows <small>Main</small></PageHeader>
        <form>
          <Row>
            <Col xs={10} md={4}>
              <FormGroup>
                <InputGroup>
                  <FormControl
                    type="text"
                    ref='searchInput'
                    value={this.state.searchValue}
                    placeholder="Buscar Show"
                    onChange={this._handleSearchInputChange}
                  />
                  <InputGroup.Button>
                    <Button
                      bsStyle="danger"
                      onClick={this._onResetSearchText}
                    >
                      Reset
                    </Button>
                  </InputGroup.Button>
                </InputGroup>
              </FormGroup>
            </Col>
            <Col xs={2}>
              <Button
                type="submit"
                onClick={this._onSearch}
              >
                Buscar
              </Button>
            </Col>
          </Row>
        </form>
        <Pagination prev next first last ellipsis maxButtons={6}
          items={this.state.items}
          activePage={this.props.page}
          onSelect={this.props.onChangePage}
        />
        <Grid>
          {tableRows}
        </Grid>
      </div>
    )
  }

  _handleSearchInputChange(e) {
    this.setState({searchValue: e.target.value});
  }

  _onSearch(e) {
    this.props.onSearchShow(this.state.searchValue);
    e.preventDefault();
  }

  _onResetSearchText() {
    this.setState({searchValue: ''});
    this.props.onSearchShow('');
  }
}
