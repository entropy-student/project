#!/usr/bin/env python3
"""Physical-content structural and numeric regression for CB01 Chapter 8.

Checks the *actual Markdown's* model values, not in-script model constants.
Does not verify legal accuracy, payment events, or real customer demand.
Usage: python CHAPTER8_SELFTEST_20261019.py /path/to/CHAPTER8_FINAL_SEALED.md
"""
from pathlib import Path
import math
import re
import sys

HEADINGS = [
    '# 8. 好几个方向都不错，我究竟该做哪个？',
    '## 8.1 怎么比较不同生意的赚钱潜力、风险和难度？',
    '### 8.1.1 比较几个方向，应该统一查看哪些赚钱、竞争、门槛和资源指标？',
    '### 8.1.2 某个方向分数很高但证据很弱，怎么避免被排名误导？',
    '## 8.2 还没完全确定的时候，应该先做还是继续调查？',
    '## 8.3 刚开始应该投入多少时间和资金？',
    '### 8.3.1 第一轮试做，怎样设定亏得起的资金和时间上限？',
    '### 8.3.2 达到什么实际证据后，才有理由增加投入？',
    '## 8.4 什么情况下应该坚持、调整方向或者及时放弃？',
    '### 8.4.1 哪些变化说明还值得坚持，哪些说明该调整客户或卖法？',
    '### 8.4.2 出现什么证据时，继续投入已不划算、应该停下？',
    '### 8.4.3 决定退出前，哪些未履行承诺和退出成本必须算清？',
]


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def near(actual, expected, name, tol=1e-6):
    require(math.isclose(actual, expected, rel_tol=0, abs_tol=tol),
            f'{name}: obtained {actual}, expected {expected}')


def first(regex, txt, desc, flags=0):
    match = re.search(regex, txt, flags)
    require(match is not None, f'Cannot parse text for {desc}')
    return match


def n(text):
    return int(text.replace(',', ''))


def check(text):
    heads = re.findall(r'^#{1,3} .+$', text, flags=re.MULTILINE)
    require(heads == HEADINGS, 'Frozen headings/order differ or unexpected H1-H3 present')
    require(not any(h.startswith('### 8.2.') for h in heads), '8.2 must not contain H3')
    print('[PASS] 12 frozen titles in exact order; 8.2 directly a section')

    weights_section = first(r'假设我们建立一个包含 6 个核心维度[\s\S]+?现在对比两个候选方向', text, 'MCDA weights').group()
    weights = [int(w) / 100 for w in re.findall(r'（权重\s*(\d+)%）', weights_section)]
    require(len(weights) == 6, f'Expected 6 *document* weights, found {weights}')
    near(sum(weights), 1.0, 'Total MCDA document weights')

    for candidate in ('X', 'Y'):
        formulae = re.findall(r'\\text\{Score\}_'+candidate+r'\s*=\s*([^\r\n]+)', text)
        require(len(formulae) == 2, f'Expected two explicit score formula lines for {candidate}')
        products = re.findall(r'(\d+(?:\.\d+)?)\s*\\times\s*(\d+(?:\.\d+)?)', formulae[0])
        require(len(products) == 6, f'Expected six {candidate} score factors from body')
        scores = [float(s) for s,w in products]
        actual_weights = [float(w) for s,w in products]
        for i, (w,expected) in enumerate(zip(actual_weights, weights), 1):
            near(w, expected, f'{candidate} factor weight {i}')
        assert all(0 <= s <= 10 for s in scores), 'Score outside 0–10 scale'
        weighted = sum(s * w for s,w in zip(scores, actual_weights))
        claimed_contributions = [float(v) for v in re.findall(r'\b\d+\.\d+\b', formulae[1].split('=')[0])]
        require(len(claimed_contributions) == 6, f'{candidate} result contribution list not extracted')
        for i,(s,w,c) in enumerate(zip(scores,actual_weights,claimed_contributions),1):
            near(s*w, c, f'{candidate} contribution {i}')
        claimed_total = float(first(r'\\mathbf\{(\d+(?:\.\d+)?)\s*\\text\{\s*分', formulae[1], candidate+' final score').group(1))
        near(sum(claimed_contributions), claimed_total, f'{candidate} contribution sum')
        near(weighted, claimed_total, f'{candidate} weighted score')
        print(f'[PASS] MCDA {candidate}: six body factors match declared weights; score={weighted:.2f}')

    budget = first(r'#### \(3\) 典型轻量测试预算构造成本示范[\s\S]*?(?=#### 2\. 时间)', text, 'budget section').group()
    parts = re.findall(r'（约 \$([\d,]+)～\$([\d,]+)）', budget)
    require(len(parts)==4, f'Expected 4 explicit budget components; found {parts}')
    mins = [n(x) for x,y in parts]
    maxs = [n(y) for x,y in parts]
    for label,vals in [('下限',mins),('上限',maxs)]:
        expr = first(r'支出'+label+r'组合：([^\r\n]+)', budget, label+' sum').group(1)
        amounts = [n(v) for v in re.findall(r'\\\$([\d,]+)', expr)]
        require(len(amounts)==len(vals)+1, f'{label} sum formula has unexpected count {amounts}')
        require(amounts[:-1] == vals, f'{label} cost terms differ from body bullet items: {amounts[:-1]} vs {vals}')
        require(sum(vals)==amounts[-1], f'{label} budget sum {sum(vals)} != stated {amounts[-1]}')
    lower,upper=sum(mins),sum(maxs)
    stated=first(r'四项现金预算合计\s*\*\*\$([\d,]+)～\$([\d,]+)\s*美元',budget,'budget prose')
    require((n(stated.group(1)),n(stated.group(2)))==(lower,upper),'Budget prose != document components')
    print(f'[PASS] Budget: {len(parts)} body component ranges and formula totals ${lower}–${upper}')

    for alpha in (20,30):
        line = next((l for l in text.splitlines() if f'\\alpha = {alpha}\\%' in l and '完成首轮测试后消耗' in l),None)
        require(line, f'Cannot find alpha={alpha}% trial narrative')
        spend = first(r'完成首轮测试后消耗\s*(\d+)%',line,'spend').group(1)
        remainder = first(r'剩余\s*(\d+)%',line,'remainder').group(1)
        further = first(r'后续\s*(?:最多仅能再支持\s*)?\*\*(\d+)\s*轮',line,'further trials').group(1)
        spend, remainder, further=int(spend),int(remainder),int(further)
        require(spend == alpha and remainder == 100-alpha, f'Trial narrative alpha {alpha}: spent {spend}, remainder {remainder}')
        require(further == remainder//alpha, f'Trial narrative alpha {alpha}: remaining trial count {further} should be {remainder//alpha}')
        require((1+further)*alpha <= 100, 'Cannot fund the claimed total trials')
        print(f'[PASS] Alpha={alpha}%: spent {spend}%, remainder {remainder}%, further equal-size trials={further}')

    print('[ALL PASS] Real document-derived checks passed; not a validation of legal facts or actual sales')


def main(argv):
    if len(argv) != 2:
        print('Usage: python CHAPTER8_SELFTEST_20261019.py path/to/CHAPTER8_FINAL_SEALED.md',file=sys.stderr)
        return 2
    path=Path(argv[1])
    if not path.is_file():
        print(f'[FAIL] Source Markdown not found: {path}',file=sys.stderr)
        return 2
    try:
        content=path.read_text(encoding='utf-8')
        check(content)
        return 0
    except (AssertionError,ValueError,UnicodeDecodeError) as exc:
        print(f'[FAIL] {exc}',file=sys.stderr)
        return 1

if __name__ == '__main__':
    sys.exit(main(sys.argv))
