'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Pager from 'react-bootstrap/lib/Pager';
import PageHeader from 'react-bootstrap/lib/PageHeader';

export default class FunctionsMain extends React.Component {
  static propTypes = {
    theater: PropTypes.object,
    functions: PropTypes.object,
    loadingContent: PropTypes.boolean,
    offsetDays: PropTypes.number,
    onChangeOffsetDays: PropTypes.func,
  };

  constructor(props) {
    super(props);
    this.state = {
      currentOffest: props.offsetDays
    }
  }

  render() {
    return (
      <div>
        <PageHeader>
          {this.props.theater.name}
          <small>  {_.upperFirst(moment().add(this.props.offsetDays, 'days').format('dddd D'))}</small>
        </PageHeader>
        {this._getPagination()}
        {this._getFunctions()}
      </div>
    );
  }

  _getFunctions() {
    if (this.props.loadingContent) {
      return(<h1>Loading...</h1>);
    }
    else {
      return this.props.functions.map((func) => {
        return(
          <Grid>
            <Row>
              <Col sm={3}>
                {func.parsed_show.name}
              </Col>
              <Col sm={3}>
                {func.show.name}
              </Col>
              <Col sm={2}>
                {func.date}
              </Col>
              <Col sm={4}>
                {func.showtimes}
              </Col>
            </Row>
          </Grid>
        );
      });
    }
  }

  _getPagination() {
    moment.locale('es-CL');
    let currDay = moment().add(this.state.currentOffest - 4, 'days');
    let dates = [_.upperFirst(currDay.format('dddd D'))];
    for(let indx = 0; indx < 9; indx++) {
      dates.push(_.upperFirst(currDay.add(1, 'days').format('dddd D')))
    }
    return (
      <Pager>
        <Pager.Item previous onSelect={() => {
          this.setState({currentOffest: this.state.currentOffest - 1})
        }}>Prev</Pager.Item>
        {dates.map((date, index) => {
          return (
            <Pager.Item onSelect={() => {
              this.props.onChangeOffsetDays(this.state.currentOffest - 4 + index);
            }}>{date}</Pager.Item>
          );
        })}
        <Pager.Item next onSelect={() => {
          this.setState({currentOffest: this.state.currentOffest + 1})
        }}>Next</Pager.Item>
      </Pager>
    );
  }
}