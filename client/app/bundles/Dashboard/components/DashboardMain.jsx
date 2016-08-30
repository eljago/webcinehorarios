'use strict';

import React, { PropTypes } from 'react';
import _ from 'lodash';
import moment from 'moment';

import Table from 'react-bootstrap/lib/Table';

const DAYS = 8;

export default class DashboardMain extends React.Component {

  static propTypes = {
    cinemas: PropTypes.array
  };

  constructor(props) {
    super(props);
    moment.locale('es-CL');
    let today = moment();
    const format = 'ddd DD';
    this.dates = [today.format(format)];
    for (let index = 0; index < DAYS-1; index++) {
      this.dates.push(today.add(1, 'days').format(format));
    }
  }
  
  render() {
    const tables = this.props.cinemas.map((cinema) => {
      const tableBody = this._getTableBody(cinema);
      return(
        <Table bordered style={{
          color: 'black',
          fontWeight: 'bold'
        }}>
          <thead>
            {this._getTableHeaders()}
          </thead>
          <tbody>
            {this._getTableBody(cinema)}
          </tbody>
        </Table>
      );
    });

    return (
      <div>
        {tables}
      </div>
    );
  }

  _getTableHeaders() {
    const ths = [<th style={{width: 200}}>{'Complejo'}</th>].concat(this.dates.map((date) => {
      return(<th style={{textAlign: 'center'}}>{date}</th>);
    }));
    return(<tr>{ths}</tr>);
  }

  _getTableBody(cinema) {
    return cinema.theaters.map((theater) => {
      const tds = [<td><a href={`/admin/theaters/${theater.slug}/functions`}>{theater.name}</a></td>]
        .concat(theater.days.map((functions_count, index) => {
        const url = `/admin/theaters/${theater.slug}/functions?date=${moment().add(index, 'days').format('YYYY-MM-DD')}`;
        return(
          <td
            style={{
              cursor: 'pointer',
              backgroundColor: `hsla(${functions_count / 10 * 120}, 67%, 80%, 1)`,
              textAlign: 'center',
            }}
            onClick={() => {
              window.location.replace(url);
            }}
          >
            {functions_count}
          </td>
        );
      }));
      return(<tr>{tds}</tr>);
    })
  }
}