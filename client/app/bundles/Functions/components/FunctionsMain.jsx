'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Nav from 'react-bootstrap/lib/Nav';
import NavItem from 'react-bootstrap/lib/NavItem';
import Image from 'react-bootstrap/lib/Image';
import Button from 'react-bootstrap/lib/Button';
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
      currentOffest: props.offsetDays,
      selectedPillDate: this._getPrettyDateString(moment())
    }
  }

  _getPrettyDateString(date) {
    return(_.upperFirst(date.format('dddd D')));
  }

  render() {
    const theater = this.props.theater;
    return (
      <div>
        <div style={{display: 'flex', flexDirection: 'row', marginBottom: 10}}>
          <span style={{flex: 1, fontSize: 26}}>
            {theater.name}
          </span>
          <span style={{flex: 1, color: 'gray', fontSize: 22}}>
            {_.upperFirst(moment().add(this.props.offsetDays, 'days').format('dddd D [de] MMMM, YYYY'))}
          </span>
          <div>
            <Button
              bsStyle="success"
              href={`/admin/theaters/${theater.slug}/functions/new?date=${moment().format('YYYY-MM-DD')}`}
            >
              Nuevo
            </Button>
          </div>
        </div>
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
              <Col sm={1}>
                <Image
                  style={styles.img}
                  src={func.show.image}
                />
              </Col>
              <Col sm={3}>
                <span style={styles.span}>{func.parsed_show ? func.parsed_show.name : ''}</span>
              </Col>
              <Col sm={3}>
                <a
                  href={`/admin/theaters/${this.props.theater.slug}/functions/${func.id}/edit`}
                  style={styles.span}
                >
                  {func.show.name}
                </a>
              </Col>
              <Col sm={2}>
                <span style={styles.span}>{func.function_types.map((ft) => {
                  return ft.name;
                }).join(', ')}</span>
              </Col>
              <Col sm={3}>
                <span style={styles.span}>{func.showtimes}</span>
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
    let dates = [this._getPrettyDateString(currDay)];
    for(let indx = 0; indx < 9; indx++) {
      dates.push(this._getPrettyDateString(currDay.add(1, 'days')));
    }

    return (
      <Nav justified bsStyle="pills" activeKey={this.state.selectedPillDate}>
        <NavItem onSelect={() => {
          this.setState({currentOffest: this.state.currentOffest - 1});
        }}>Prev</NavItem>

        {dates.map((date, index) => {
          return (
            <NavItem eventKey={date} onSelect={() => {
              this.setState({selectedPillDate: date});
              this.props.onChangeOffsetDays(this.state.currentOffest - 4 + index);
            }}>
              {date}
            </NavItem>
          );
        })}

        <NavItem onSelect={() =>{
          this.setState({currentOffest: this.state.currentOffest + 1});
        }}>Next</NavItem>
      </Nav>
    );
  }
}

const styles = {
  img: {
    width: 40,
    height: 60,
    "objectFit": 'cover'
  },
  span: {
    fontSize: 18
  }
}