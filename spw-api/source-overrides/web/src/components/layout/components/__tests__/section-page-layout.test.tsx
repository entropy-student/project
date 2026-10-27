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

import { PageFooterPortal } from '../page-footer'
import { SectionPageLayout } from '../section-page-layout'

describe('workspace page layout', () => {
  it('gives the heading a full mobile row when primary actions would otherwise squeeze it', () => {
    render(
      <SectionPageLayout>
        <SectionPageLayout.Title>API Keys</SectionPageLayout.Title>
        <SectionPageLayout.Actions>
          <button type='button'>Create API Key</button>
          <button type='button'>API Addresses</button>
        </SectionPageLayout.Actions>
        <SectionPageLayout.Content>Page data</SectionPageLayout.Content>
      </SectionPageLayout>
    )
    expect(
      screen.getByRole('heading', { name: 'API Keys' }).parentElement
    ).toHaveClass('max-sm:basis-full')
    expect(screen.getByRole('button', { name: 'Create API Key' })).toBeVisible()
    expect(screen.getByRole('button', { name: 'API Addresses' })).toBeVisible()
  })

  it('preserves internal scrolling and pagination outside the fixed content region', () => {
    const view = render(
      <SectionPageLayout fixedContent>
        <SectionPageLayout.Title>Usage Logs</SectionPageLayout.Title>
        <SectionPageLayout.Content>
          <p>Page data</p>
          <PageFooterPortal>
            <button type='button'>Next page</button>
          </PageFooterPortal>
        </SectionPageLayout.Content>
      </SectionPageLayout>
    )
    const body = view.container.querySelector('.spw-page-body')
    expect(body).toHaveClass('min-h-0', 'overflow-hidden')
    const next = screen.getByRole('button', { name: 'Next page' })
    expect(body).not.toContainElement(next)
    expect(view.container.querySelector('.spw-page-footer')).toContainElement(
      next
    )
  })
})
