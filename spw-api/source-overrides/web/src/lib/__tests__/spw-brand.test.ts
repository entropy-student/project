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
import { describe, expect, it } from 'vitest'

import { displaySystemLogo, displaySystemName } from '../spw-brand'

describe('SPW presentation branding', () => {
  it.each([undefined, null, '', 'New API', 'new-api', 'newapi'])(
    'displays SPW for the uncustomized upstream name %s',
    (name) => expect(displaySystemName(name)).toBe('SPW API')
  )

  it('preserves administrator-supplied site names', () => {
    expect(displaySystemName('My private gateway')).toBe('My private gateway')
  })

  it.each([undefined, null, '', '/logo.png', '/logo.svg', '/favicon.ico'])(
    'replaces only default artwork %s',
    (logo) => expect(displaySystemLogo(logo)).toBe('/spw/mark.svg')
  )

  it('preserves an administrator logo URL including its query', () => {
    const logo = 'https://assets.example.com/logo.png?v=2'
    expect(displaySystemLogo(logo)).toBe(logo)
  })
})
