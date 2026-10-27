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
import userEvent from '@testing-library/user-event'
import type { AnchorHTMLAttributes } from 'react'
import { describe, expect, it, vi } from 'vitest'

import { OverviewUsageChart } from '../overview-usage-chart'

vi.mock('@tanstack/react-router', () => ({
  Link: ({
    to,
    ...props
  }: AnchorHTMLAttributes<HTMLAnchorElement> & { to: string }) => (
    <a {...props} href={to} />
  ),
}))

const props = {
  usage: [500, 0, 600],
  requests: [1, 0, 2],
  startTimestamp: 1729944000,
  endTimestamp: 1730030400,
  hasData: true,
  loading: false,
  error: false,
  onRetry: vi.fn(),
}

describe('overview usage chart', () => {
  it('switches between real usage and request series with keyboard-accessible tabs', async () => {
    const user = userEvent.setup()
    render(<OverviewUsageChart {...props} />)
    expect(
      screen.getByRole('img', { name: 'Usage, Last 24 hours' })
    ).toBeVisible()
    await user.click(screen.getByRole('tab', { name: 'Requests' }))
    expect(screen.getByRole('tab', { name: 'Requests' })).toHaveAttribute(
      'aria-selected',
      'true'
    )
    expect(
      screen.getByRole('img', { name: 'Requests, Last 24 hours' })
    ).toBeVisible()
    expect(
      screen.queryByRole('img', { name: 'Usage, Last 24 hours' })
    ).not.toBeInTheDocument()
    await user.keyboard('{Home}')
    expect(screen.getByRole('tab', { name: 'Usage' })).toHaveFocus()
  })

  it('shows an honest empty state when no usage records exist', () => {
    render(<OverviewUsageChart {...props} hasData={false} />)
    expect(screen.getByText('No recent usage')).toBeVisible()
    expect(screen.queryByRole('img')).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Usage Logs' })).toHaveAttribute(
      'href',
      '/usage-logs'
    )
  })

  it('keeps a real zero-valued record visible instead of treating it as fabricated or missing', () => {
    render(<OverviewUsageChart {...props} usage={[0]} requests={[0]} />)
    expect(
      screen.getByRole('img', { name: 'Usage, Last 24 hours' })
    ).toBeVisible()
    expect(screen.queryByText('No recent usage')).not.toBeInTheDocument()
  })

  it('shows loading without presenting an empty or error state', () => {
    render(<OverviewUsageChart {...props} loading error hasData={false} />)
    expect(screen.getByText('Loading...')).toBeVisible()
    expect(screen.queryByText('No recent usage')).not.toBeInTheDocument()
    expect(
      screen.queryByRole('button', { name: 'Retry' })
    ).not.toBeInTheDocument()
  })

  it('keeps the original retry callback available after loading fails', async () => {
    const user = userEvent.setup()
    const retry = vi.fn()
    render(<OverviewUsageChart {...props} error onRetry={retry} />)
    await user.click(screen.getByRole('button', { name: 'Retry' }))
    expect(retry).toHaveBeenCalledOnce()
    expect(screen.queryByRole('img')).not.toBeInTheDocument()
  })
})
