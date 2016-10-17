'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'
import update from 'react/lib/update';

import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';
import Button from 'react-bootstrap/lib/Button';

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
    return(_.upperFirst(date.format('ddd D')));
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
                <img
                  style={styles.img}
                  src={`http://cinehorarios.cl${func.show.image}`}
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

    let navItems = [
      <li>
        <a href="#" aria-label="Previous" onClick={(e) => {
          this.setState({currentOffest: this.state.currentOffest - 1});
          e.preventDefault();
        }}>
        <span aria-hidden="true">&laquo;</span>
        </a>
      </li>,
      <li>
        <a href="#" aria-label="Next" onClick={(e) => {
          this.setState({currentOffest: this.state.currentOffest + 1});
          e.preventDefault();
        }}>
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    ];
    const dateNavItems = dates.map((date, index) => {
      const active = this.state.selectedPillDate === date ? {className: 'active'} : null;
      return (
        <li {...active}>
          <a href="#" onClick={(e) => {
            this.setState({selectedPillDate: date});
            this.props.onChangeOffsetDays(this.state.currentOffest - 4 + index);
            e.preventDefault();
          }}>
            <span>{date}</span>
          </a>
        </li>
      );
    });
    navItems = update(navItems, {$splice: [[1, 0, dateNavItems]]})

    return (
      <nav aria-label="Page navigation">
        <ul className="pagination pagination-lg">
          {navItems}
        </ul>
      </nav>
    );
  }
}

const styles = {
  img: {
    width: 60,
    height: 80,
    "objectFit": 'cover'
  },
  span: {
    fontSize: 18
  }
}