//  This file is part of Sulis, a turn based RPG written in Rust.
//  Copyright 2018 Jared Stephen
//
//  Sulis is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Sulis is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Sulis.  If not, see <http://www.gnu.org/licenses/>

use std::time::Duration;
use std::cmp;
use std::rc::Rc;
use std::cell::RefCell;

mod attack_animation;
pub use self::attack_animation::AttackAnimation;

mod move_animation;
pub use self::move_animation::MoveAnimation;

mod wait_animation;
pub use self::wait_animation::WaitAnimation;

use {AreaState, EntityState};

use sulis_engine::io::GraphicsRenderer;
use sulis_engine::util::Point;

pub trait Animation {
    fn update(&mut self, area_state: &mut AreaState) -> bool;

    /// this method is called whenever another animation is added for the
    /// given entity.  This can be used to cancel this animation if the
    /// other animation should override it, for example.
    fn check(&mut self, _entity: &Rc<RefCell<EntityState>>) { }

    fn get_owner(&self) -> &Rc<RefCell<EntityState>>;

    fn draw_graphics_mode(&self, _renderer: &mut GraphicsRenderer, _pixel_size: Point) { }
}

/// Helper function to return the number of milliseconds elapsed in
/// the given duration.
pub fn get_elapsed_millis(elapsed: Duration) -> u32 {
    (elapsed.as_secs() as u32) * 1_000 +
        elapsed.subsec_nanos() / 1_000_000
}

/// Helper function to return a string representation of the elapsed time
/// in seconds
pub fn format_elapsed_secs(elapsed: Duration) -> String {
    let secs = elapsed.as_secs() as f64 + elapsed.subsec_nanos() as f64 * 1e-9;
    format!("{:.6}", secs)
}

/// Helper function to return the number of frames elapsed for the 'elapsed'
/// duration.  This is equal to the duration divided by 'frame_time'.  The
/// value is capped by 'max_index'
pub fn get_current_frame(elapsed: Duration, frame_time:
                         u32, max_index: usize) -> usize {
    let millis = get_elapsed_millis(elapsed);

    let frame_index = (millis / frame_time) as usize;

    cmp::min(frame_index, max_index)
}