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
import type { AnchorHTMLAttributes } from 'react'
import { describe, expect, it, vi } from 'vitest'

import { GlacierHome } from '../components/glacier-home'

// Routing is the boundary here; authorization remains with the existing route guards.
vi.mock('@tanstack/react-router', () => ({
  Link: (props: AnchorHTMLAttributes<HTMLAnchorElement> & { to: string }) => {
    const { to, ...rest } = props
    return <a {...rest} href={to} />
  },
}))

describe('Glacier homepage navigation', () => {
  it('sends a visitor to existing registration and preserves service destinations', () => {
    render(<GlacierHome isAuthenticated={false} />)
    expect(screen.getByRole('button', { name: 'Get Started' })).toHaveAttribute(
      'href',
      '/sign-up'
    )
    expect(
      screen.queryByText('A clear path from model to application.')
    ).not.toBeInTheDocument()
    const rail = screen.getByRole('navigation', { name: 'Explore SPW API' })
    const destinations = [...rail.querySelectorAll('a')].map((link) =>
      link.getAttribute('href')
    )
    expect(destinations).toEqual(['/pricing', '/keys', '/wallet'])
  })

  it('sends a signed-in user to the existing dashboard', () => {
    render(<GlacierHome isAuthenticated />)
    expect(
      screen.getByRole('button', { name: 'Go to Dashboard' })
    ).toHaveAttribute('href', '/dashboard')
    expect(
      screen.queryByRole('button', { name: 'Get Started' })
    ).not.toBeInTheDocument()
  })
})
