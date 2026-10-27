/*
Copyright (C) 2023-2026 QuantumNous

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

For commercial licensing, please contact support@quantumnous.com
*/
import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'

import { WalletStatsCard } from '../components/wallet-stats-card'

describe('wallet summary', () => {
  it('keeps balance above cumulative usage in the dedicated account column', () => {
    const view = render(<WalletStatsCard user={null} />)
    expect(screen.getByText('Current Balance')).toBeVisible()
    expect(screen.getByText('Total Usage')).toBeVisible()
    expect(screen.getByText('API Requests')).toBeVisible()
    expect(view.container.firstElementChild).toHaveClass('grid-cols-2')
    expect(view.container.firstElementChild).not.toHaveClass('sm:grid-cols-4')
    expect(
      screen.getByText('Current Balance').parentElement?.parentElement
    ).toHaveClass('col-span-2')
    expect(screen.getByText('Remaining quota')).toBeVisible()
    expect(screen.getByText('Total consumed quota')).toBeVisible()
  })

  it('announces loading without presenting placeholder amounts as real balances', () => {
    render(<WalletStatsCard user={null} loading />)
    expect(screen.getByRole('status', { name: 'Loading...' })).toHaveClass(
      'grid-cols-2'
    )
    expect(screen.queryByText('Current Balance')).not.toBeInTheDocument()
  })
})
