defmodule BattleMapTest do
  use ExUnit.Case
  alias BattleMap.{Barbarian, Wizard, ConeCaster, Character}

  @doc"""

             ####### 
              ##### 
               ###
                #
                ^ 
                |
              {0,0}
  """

  describe "ConeCaster" do
    test "can attack in north facing cone" do
      cone_caster = %ConeCaster{facing: :north}
      test_cases = [
        %{origin: {0,0}, target: {0,1}},
        %{origin: {0,0}, target: {1,1}},
        %{origin: {0,0}, target: {2,3}},
        %{origin: {0,0}, target: {-2,3}},
      ] 

      Enum.map(test_cases, fn case -> 
        assert Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    @doc """

               #
              ##
             ###  
    {0,0}-> ####
             ###  
              ##
               #
    """

    test "can attack in east facing cone" do
      cone_caster = %ConeCaster{facing: :east}
      test_cases = [
        %{origin: {0,0}, target: {1,0}},
        %{origin: {0,0}, target: {1,1}},
        %{origin: {0,0}, target: {3,2}},
        %{origin: {0,0}, target: {3,-2}},
        %{origin: {0,0}, target: {3,3}},
      ] 

      Enum.map(test_cases, fn case -> 
        assert Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    @doc """
              {0,0}
                |
                v
                #
               ###
              ##### 
             ####### 
    """
    test "can attack in south facing cone" do
      cone_caster = %ConeCaster{facing: :south}
      test_cases = [
        %{origin: {0,0}, target: {0,-1}},
        %{origin: {0,0}, target: {1,-1}},
        %{origin: {0,0}, target: {2,-3}},
        %{origin: {0,0}, target: {-2,-3}},
        %{origin: {0,0}, target: {-3,-3}},
      ] 

      Enum.map(test_cases, fn case -> 
        assert Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    @doc"""
    #   
    ##  
    ###   
    ####<-{0,0}
    ###   
    ##  
    #   
    """
    test "can attack in west facing cone" do
      cone_caster = %ConeCaster{facing: :west}
       test_cases = [
        %{origin: {0,0}, target: {-1,0}},
        %{origin: {0,0}, target: {-1,1}},
        %{origin: {0,0}, target: {-2,-2}},
        %{origin: {0,0}, target: {-3, 3}},
      ] 

      Enum.map(test_cases, fn case -> 
        assert Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    test "cannot attack outside of north cone when facing north" do
      cone_caster = %ConeCaster{facing: :north}
      test_cases = [
        %{origin: {0,0}, target: {-5,2}},
        %{origin: {0,0}, target: {3,1}},
        %{origin: {0,0}, target: {2,-1}},
        %{origin: {0,0}, target: {-2,1}},
      ] 

      Enum.map(test_cases, fn case -> 
        refute Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    test "cannot attack outside of east cone when facing east" do
      cone_caster = %ConeCaster{facing: :east}
      test_cases = [
        %{origin: {0,0}, target: {1,4}},
        %{origin: {0,0}, target: {1,-4}},
        %{origin: {0,0}, target: {3,6}},
        %{origin: {0,0}, target: {-3,-2}},
        %{origin: {0,0}, target: {3,-6}},
      ] 

      Enum.map(test_cases, fn case -> 
        refute Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    test "cannot attack outside of south cone when facing south" do
      cone_caster = %ConeCaster{facing: :south}
      test_cases = [
        %{origin: {0,0}, target: {0,1}},
        %{origin: {0,0}, target: {1,1}},
        %{origin: {0,0}, target: {2,-1}},
        %{origin: {0,0}, target: {1,0}},
        %{origin: {0,0}, target: {-3,-2}},
      ] 

      Enum.map(test_cases, fn case -> 
        refute Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end

    test "cannot attack outside of west cone when facing west" do
      cone_caster = %ConeCaster{facing: :west}
      test_cases = [
        %{origin: {0,0}, target: {1,0}},
        %{origin: {0,0}, target: {-1,3}},
        %{origin: {0,0}, target: {-2,-4}},
        %{origin: {0,0}, target: {-3, 6}},
      ] 

      Enum.map(test_cases, fn case -> 
        refute Character.can_attack?(cone_caster, case.origin, case.target)
      end)
    end
  end

  describe "Wizard" do
    test "can attack in eight directions" do
      # up, up-right, right, down-right, down, down-left, left, up-left
      assert Character.can_attack?(%Wizard{}, {4, 4}, {4, 5})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {5, 5})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {5, 4})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {5, 3})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {4, 3})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {3, 3})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {3, 4})
      assert Character.can_attack?(%Wizard{}, {4, 4}, {3, 5})
    end

    test "cannot attack invalid squares" do
      refute Character.can_attack?(%Wizard{}, {4, 4}, {6, 5})
      refute Character.can_attack?(%Wizard{}, {4, 4}, {2, 5})
      refute Character.can_attack?(%Wizard{}, {4, 4}, {3, 2})
      refute Character.can_attack?(%Wizard{}, {4, 4}, {6, 3})
    end
  end

  describe "Barbarian" do
    test "can attack within two squares of current position" do
      for x <- 2..6, y <- 2..6 do
        assert Character.can_attack?(%Barbarian{}, {4, 4}, {x, y})
      end
    end

    test "cannot attack beyond two squares of current position" do
      refute Character.can_attack?(%Barbarian{}, {4, 4}, {1, 1})
      refute Character.can_attack?(%Barbarian{}, {4, 4}, {7, 7})
      refute Character.can_attack?(%Barbarian{}, {4, 4}, {7, 1})
      refute Character.can_attack?(%Barbarian{}, {4, 4}, {1, 7})
    end

    test "logic is not hardcoded to the {4, 4} position" do
      refute Character.can_attack?(%Barbarian{}, {3, 3}, {6, 6})
    end
  end
end
