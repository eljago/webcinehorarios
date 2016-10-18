'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import moment from 'moment'
import update from 'react/lib/update';

export default class DatePagination extends React.Component {

  static propTypes = {
    onChangeDay: PropTypes.func,
  };

  constructor(props) {
    super(props);
    moment.locale('es-CL');
    this.state = {
      currentOffest: props.offsetDays,
      selectedPillDate: this._getPrettyDateString(moment()) // "Mier 19"
    }
    _.bindAll(this, ['_onClickPrev', '_onClickNext'])
  }

  render() {
    let currDay = moment().add(this.state.currentOffest - 4, 'days');
    let dates = [this._getPrettyDateString(currDay)];
    for(let indx = 0; indx < 9; indx++) {
      dates.push(this._getPrettyDateString(currDay.add(1, 'days')));
    }
    // dates: ["Lun 17", "Mar 18", "Mier 19", etc...]

    let navItems = [
      <li>
        <a href="#" aria-label="Previous" onClick={this._onClickPrev}>
        <span aria-hidden="true">&laquo;</span>
        </a>
      </li>,
      <li>
        <a href="#" aria-label="Next" onClick={this._onClickNext}>
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    ];

    const dateNavItems = dates.map((date, index) => {
      const active = this.state.selectedPillDate === date ? {className: 'active'} : null;
      return (
        <li {...active}>
          <a href="#" onClick={(e) => this._onClickDate(e, index)}>
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

  _onClickPrev(e) {
    this.setState({currentOffest: this.state.currentOffest - 1});
    e.preventDefault();
  }

  _onClickNext(e) {
    this.setState({currentOffest: this.state.currentOffest + 1});
    e.preventDefault();
  }

  _onClickDate(e, index) {
    this.setState({selectedPillDate: date});
    this.props.onChangeDay(this.state.currentOffest - 4 + index);
    e.preventDefault();
  }

  _getPrettyDateString(date) {
    return(_.upperFirst(date.format('ddd D')));
  }
}