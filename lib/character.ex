alias BattleMap.{Barbarian, Wizard, ConeCaster}

defprotocol BattleMap.Character do
  def can_attack?(character, origin, target)
end

defimpl BattleMap.Character, for: Barbarian do
  def can_attack?(_character, {ox, oy}, {tx, ty}) do
    case [abs(ox - tx), abs(oy - ty)] do
      [distx, disty] when distx <= 2 and disty <= 2 -> true
      _ -> false
    end
  end
end

defimpl BattleMap.Character, for: Wizard do
  # catches straight lines
  def can_attack?(_character, {ox, oy} = _origin, {tx, ty} = _target) when ox == tx or oy == ty, do: true

  # catches diagonals, line slope will always be 1
  def can_attack?(_character, origin = _origin, target = _target) do
    if abs_slope(origin, target) == 1 do
      true
    else
      false
    end
  end

  # gets absolute value of slope, we don't care about sign in this case since
  # we draw all four straight lines from the origin.
  defp abs_slope({ox, oy} = _origin, {tx, ty} = _target) do
    div(abs(oy - ty), abs(ox - tx))
  end
end

defimpl BattleMap.Character, for: ConeCaster do

  def can_attack?(%{facing: :north}, origin, target) do
    on_or_above_line(origin, 1, target) and on_or_above_line(origin, -1, target)
  end

  def can_attack?(%{facing: :east}, origin, {x, y} = _target) do
    can_attack?(%{facing: :north}, origin, {y, x})   
  end

  def can_attack?(%{facing: :south}, origin, {x, y} = _target) do
    can_attack?(%{facing: :north}, origin, {x, -y}) 
  end

  def can_attack?(%{facing: :west}, origin, {x, y} = _target) do
    can_attack?(%{facing: :north}, origin, {y, -x}) 
  end

  defp on_or_above_line({ox, oy} = _origin, slope, {tx, ty} = _target) do
    delta_x = tx - ox
    delta_y = slope * delta_x
    ty >= oy + delta_y
  end
end

