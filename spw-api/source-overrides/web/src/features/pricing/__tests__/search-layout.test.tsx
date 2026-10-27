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
import { useState } from 'react'
import { describe, expect, it } from 'vitest'

import { SearchBar } from '../components/search-bar'

function SearchExample() {
  const [value, setValue] = useState('')
  return (
    <SearchBar value={value} onChange={setValue} onClear={() => setValue('')} />
  )
}

describe('model search', () => {
  it('keeps keyboard focus and clearing available in the compact catalog header', async () => {
    const user = userEvent.setup()
    render(<SearchExample />)
    const input = screen.getByRole('textbox', { name: 'Search models' })
    await user.keyboard('{Control>}k{/Control}')
    expect(input).toHaveFocus()
    await user.type(input, 'long-model-name')
    expect(input).toHaveValue('long-model-name')
    await user.click(screen.getByRole('button', { name: 'Clear search' }))
    expect(input).toHaveValue('')
    input.focus()
    await user.keyboard('{Escape}')
    expect(input).not.toHaveFocus()
  })
})
