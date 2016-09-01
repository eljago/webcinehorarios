'use strict';

import React, { PropTypes } from 'react';

import Button from 'react-bootstrap/lib/Button';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import FormGroup from 'react-bootstrap/lib/FormGroup';
import FormControl from 'react-bootstrap/lib/FormControl';
import InputGroup from 'react-bootstrap/lib/InputGroup';

export default class SearchField extends React.Component {
  static propTypes = {
    placeholder: PropTypes.string,
    onSearch: PropTypes.func,
    onChange: PropTypes.func,
    disabled: PropTypes.boolean,
  };

  constructor(props) {
    super(props);
    this.state = {
      searchValue: '',
    };
    _.bindAll(this, [
      '_onSearch',
      '_handleSearchInputChange',
      '_onResetSearchText',
    ]);
  }

  render() {
    return (
      <form>
        <Row>
          <Col xs={12} sm={8}>
            <FormGroup>
              <InputGroup>
                <FormControl
                  type="text"
                  value={this.state.searchValue}
                  placeholder={this.props.placeholder}
                  onChange={this._handleSearchInputChange}
                  disabled={this.props.disabled}
                />
                <InputGroup.Button>
                  <Button
                    bsStyle="danger"
                    onClick={this._onResetSearchText}
                    disabled={this.props.disabled}
                  >
                    Reset
                  </Button>
                </InputGroup.Button>
              </InputGroup>
            </FormGroup>
          </Col>
          <Col xs={12} sm={4}>
            <Button
              type="submit"
              onClick={this._onSearch}
              disabled={this.props.disabled}
              block
            >
              Buscar
            </Button>
          </Col>
        </Row>
      </form>
    )
  }

  _handleSearchInputChange(e) {
    this.setState({searchValue: e.target.value});
    if (this.props.onChange) {
      this.props.onChange(e.target.value);
    }
  }

  _onResetSearchText() {
    this.setState({searchValue: ''});
    if (this.props.onChange) {
      this.props.onChange('');
    }
    this.props.onSearch('');
  }

  _onSearch(e) {
    this.props.onSearch(this.state.searchValue);
    e.preventDefault();
  }
}