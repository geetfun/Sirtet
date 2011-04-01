#
#  Field.rb
#  sirtet
#
#  Created by Thomas R. Koll on 01.04.11.
#  Copyright 2011 Ananasblau.com. All rights reserved.
#


class TowerView < NSView
  include GameHelper
  attr_accessor :game
  attr_accessor :game_view
  attr_accessor :block_position

  def block_size
    game_view.block_size
  end

  def drawRect rect
    with_context do
      game.tower.drawRect(rect, block_size)
    end
    draw_block if self.block_position
  end

  def mouseDown(event)
    point = self.point_in_grid(convertPoint event.locationInWindow, fromView:nil)
    self.block_position = point if game.next_block_fits?(point.x/block_size, point.y/block_size)
  end

  def point_in_grid(point)
    NSPoint.new(point.x - (point.x % block_size), point.y - (point.y % block_size))
  end

  def mouseUp(event)
    self.block_position = nil
  end

  def draw_block
    with_context do
      transform = NSAffineTransform.transform
      transform.translateXBy self.block_position.x, yBy: self.block_position.y
      transform.concat
      NSColor.whiteColor.colorWithAlphaComponent(0.2).set
      game.next_block.drawRect(frame, block_size)
    end
    setNeedsDisplay true
  end
end
